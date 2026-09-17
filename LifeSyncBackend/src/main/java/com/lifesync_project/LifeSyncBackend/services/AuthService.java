package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Auth.*;
import com.lifesync_project.LifeSyncBackend.dto.Users.RegisterRequest;
import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.exception.BadRequestException;
import com.lifesync_project.LifeSyncBackend.exception.DuplicateResourceException;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.exception.UnauthorizedException;
import com.lifesync_project.LifeSyncBackend.exception.OtpLimitException;
import com.lifesync_project.LifeSyncBackend.repository.UserRepository;
import com.lifesync_project.LifeSyncBackend.security.JwtService;
import com.lifesync_project.LifeSyncBackend.utils.OtpGenerator;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Transactional
public class AuthService {

    private final EmailService emailService;
    private final TelegramService telegramService;
    private final OtpPolicy otpPolicy;
    private final OtpGenerator otpGenerator;
    private final UserRepository userRepository;

    private final AuthenticatedUserService authenticatedUserService;

    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    /*
     * Check if email already exists
     */
    public boolean checkEmailExists(String email) {
        if (email == null || email.isBlank()) {
            return false;
        }
        return userRepository.existsByEmailIgnoreCase(email.trim().toLowerCase());
    }

    /*
     * Register
     */
    public String register(RegisterRequest request) {
        String email = request.getEmail() == null ? "" : request.getEmail().trim().toLowerCase();

        if (userRepository.existsByEmailIgnoreCase(email)) {
            throw new DuplicateResourceException("email already exists");
        }

        if (request.getPhoneNumber() != null
                && userRepository.existsByPhoneNumber(request.getPhoneNumber().trim())) {
            throw new DuplicateResourceException("phone number already exists");
        }

        Users user = Users.builder()
                .fullName(request.getFullName().trim())
                .email(email)
                .phoneNumber(request.getPhoneNumber() == null ? null : request.getPhoneNumber().trim())
                .password(passwordEncoder.encode(request.getPassword()))
                .verified(false)
                .otpCode(otpGenerator.generateOtp())
                .otpExpiredAt(LocalDateTime.now().plusMinutes(5))
                .otpPurpose("registration")
                .otpLastSentAt(LocalDateTime.now())
                .build();

        userRepository.save(user);


        emailService.sendOtpEmail(
                user.getEmail(),
                user.getOtpCode());
        return "Register successfully. Please verify your OTP.";
    }

    /*
     * Login
     */
    public LoginResponse login(LoginRequest request) {
        String email = request.getEmail() == null ? "" : request.getEmail().trim().toLowerCase();

        Users user = userRepository.findByEmailIgnoreCase(email)
                .orElseThrow(() ->
                        new UnauthorizedException("Incorrect email or password."));

        if (!passwordEncoder.matches(
                request.getPassword(),
                user.getPassword())) {

            throw new UnauthorizedException("password wrong");
        }

        if (!user.getVerified()) {
            throw new UnauthorizedException("account not verified");
        }

        return LoginResponse.builder()
                .accessToken(jwtService.generateToken(user))
                .tokenType("Bearer")
                .userId(user.getId())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .build();
    }

    /*
     * Verify OTP
     */
    @Transactional(dontRollbackOn = {BadRequestException.class, OtpLimitException.class})
    public String verifyOtp(VerifyOtpRequest request) {
        String email = request.getEmail() == null ? "" : request.getEmail().trim().toLowerCase();

        Users user = userRepository.findForOtpByEmail(email)
                .orElseThrow(() ->
                        new ResourceNotFoundException("email not found"));

        otpPolicy.verify(user, request.getOtpCode(), "registration", LocalDateTime.now());

        user.setVerified(true);
        user.setOtpCode(null);
        user.setOtpExpiredAt(null);

        userRepository.save(user);

        return "Account verified successfully.";
    }

    /*
     * Resend OTP
     */
    @Transactional(dontRollbackOn = {BadRequestException.class, OtpLimitException.class, IllegalStateException.class})
    public String resendOtp(String email) {
        return resendOtp(email, "email");
    }

    @Transactional(dontRollbackOn = {BadRequestException.class, OtpLimitException.class, IllegalStateException.class})
    public String resendOtp(String email, String channel) {

        Users user = userRepository.findForOtpByEmail(email.trim())
                .orElseThrow(() ->
                        new ResourceNotFoundException("email not found"));

        otpPolicy.check(user, LocalDateTime.now());
        if (Boolean.TRUE.equals(user.getVerified()) && !"reset".equals(user.getOtpPurpose())) {
            throw new BadRequestException("Start password recovery first.");
        }

        if (!"email".equals(channel) && !"telegram".equals(channel)) {
            throw new BadRequestException("Unsupported OTP channel.");
        }
        boolean telegram = "telegram".equals(channel);
        if (telegram && (user.getTelegramChatId() == null || user.getTelegramChatId().isBlank())) {
            throw new BadRequestException("Telegram is not linked to this account. Use Gmail or contact support.");
        }
        otpPolicy.send(user, telegram, LocalDateTime.now());
        user.setOtpPurpose(Boolean.TRUE.equals(user.getVerified()) ? "reset" : "registration");

        user.setOtpCode(otpGenerator.generateOtp());
        user.setOtpExpiredAt(
                LocalDateTime.now().plusMinutes(5));

        userRepository.save(user);


        if (telegram) {
            if (!telegramService.sendOtpMessage(user.getTelegramChatId(), user.getOtpCode())) {
                throw new IllegalStateException("Telegram delivery failed. Please try again later.");
            }
        } else {
            emailService.sendOtpEmail(user.getEmail(), user.getOtpCode());
        }
        return "OTP has been resent.";
    }

    /*
     * Forgot Password
     */
    @Transactional(dontRollbackOn = {BadRequestException.class, OtpLimitException.class, IllegalStateException.class})
    public String forgotPassword(ForgotPasswordRequest request) {
        String email = request.getEmail() == null ? "" : request.getEmail().trim().toLowerCase();

        Users user = userRepository.findForOtpByEmail(email)
                .orElseThrow(() ->
                        new ResourceNotFoundException("email not found"));

        otpPolicy.send(user, false, LocalDateTime.now());
        user.setOtpPurpose("reset");
        user.setOtpCode(otpGenerator.generateOtp());
        user.setOtpExpiredAt(
                LocalDateTime.now().plusMinutes(5));

        userRepository.save(user);


        // Send Email
        emailService.sendOtpEmail(
                user.getEmail(),
                user.getOtpCode());

        return "OTP sent to email.";
    }

    /*
     * Reset Password
     */
    @Transactional(dontRollbackOn = {BadRequestException.class, OtpLimitException.class})
    public String resetPassword(
            ResetPasswordRequest request) {
        String email = request.getEmail() == null ? "" : request.getEmail().trim().toLowerCase();

        Users user = userRepository.findForOtpByEmail(email)
                .orElseThrow(() ->
                        new ResourceNotFoundException("email not found"));

        otpPolicy.verify(user, request.getOtpCode(), "reset", LocalDateTime.now());

        user.setPassword(
                passwordEncoder.encode(
                        request.getNewPassword()));

        user.setOtpCode(null);
        user.setOtpExpiredAt(null);

        userRepository.save(user);

        return "Password reset successfully.";
    }

    /*
     * Change Password
     */
    public String changePassword(
            Long id,
            ChangePasswordRequest request) {

        Users user = authenticatedUserService.requireOwner(id);

        if (!passwordEncoder.matches(
                request.getCurrentPassword(),
                user.getPassword())) {

            throw new BadRequestException("password wrong");
        }

        user.setPassword(
                passwordEncoder.encode(
                        request.getNewPassword()));

        userRepository.save(user);

        return "Password changed successfully.";
    }

    /*
     * Logout
     */
    @Transactional(dontRollbackOn = {BadRequestException.class, OtpLimitException.class, IllegalStateException.class})
    public String linkTelegram(String chatId) {
        Users current = authenticatedUserService.requireCurrentUser();
        Users user = userRepository.findForOtpByEmail(current.getEmail()).orElseThrow();
        if (!Boolean.TRUE.equals(user.getVerified())) {
            throw new BadRequestException("Verify your email before linking Telegram.");
        }
        Integer emailAttempts = user.getOtpEmailAttempts();
        otpPolicy.send(user, false, LocalDateTime.now());
        user.setOtpEmailAttempts(emailAttempts);
        user.setPendingTelegramChatId(chatId);
        user.setOtpPurpose("telegram-link");
        user.setOtpCode(otpGenerator.generateOtp());
        user.setOtpExpiredAt(LocalDateTime.now().plusMinutes(5));
        if (!telegramService.sendOtpMessage(chatId, user.getOtpCode())) {
            throw new IllegalStateException("Telegram delivery failed. Start the bot in a private chat and try again.");
        }
        return "Check Telegram for your linking code.";
    }

    @Transactional(dontRollbackOn = {BadRequestException.class, OtpLimitException.class})
    public String confirmTelegram(String code) {
        Users current = authenticatedUserService.requireCurrentUser();
        Users user = userRepository.findForOtpByEmail(current.getEmail()).orElseThrow();
        otpPolicy.verify(user, code, "telegram-link", LocalDateTime.now());
        user.setTelegramChatId(user.getPendingTelegramChatId());
        user.setPendingTelegramChatId(null);
        return "Telegram linked successfully.";
    }

    public String logout() {

        return "Logout successful.";
    }

}
