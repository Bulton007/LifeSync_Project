package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Auth.*;
import com.lifesync_project.LifeSyncBackend.dto.Auth.RegisterRequest;
import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.exception.BadRequestException;
import com.lifesync_project.LifeSyncBackend.exception.DuplicateResourceException;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.exception.UnauthorizedException;
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
    private final OtpGenerator otpGenerator;
    private final UserRepository userRepository;

    private final AuthenticatedUserService authenticatedUserService;

    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    /*
     * Register
     */
    public String register(RegisterRequest request) {

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new DuplicateResourceException("Email already exists.");
        }

        if (request.getPhoneNumber() != null
                && userRepository.existsByPhoneNumber(request.getPhoneNumber())) {
            throw new DuplicateResourceException("Phone number already exists.");
        }

        Users user = Users.builder()
                .fullName(request.getFullName())
                .email(request.getEmail())
                .phoneNumber(request.getPhoneNumber())
                .password(passwordEncoder.encode(request.getPassword()))
                .verified(false)
                .otpCode(otpGenerator.generateOtp())
                .otpExpiredAt(LocalDateTime.now().plusMinutes(5))
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

        Users user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found"));

        if (!passwordEncoder.matches(
                request.getPassword(),
                user.getPassword())) {

            throw new UnauthorizedException("Incorrect email or password.");
        }

        if (!user.getVerified()) {
            throw new UnauthorizedException("Account is not verified.");
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
    public String verifyOtp(VerifyOtpRequest request) {

        Users user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found"));

        if (user.getOtpCode() == null || !user.getOtpCode().equals(request.getOtpCode())) {
            throw new BadRequestException("Invalid OTP.");
        }

        if (user.getOtpExpiredAt() == null || user.getOtpExpiredAt().isBefore(LocalDateTime.now())) {
            throw new BadRequestException("OTP expired.");
        }

        user.setVerified(true);
        user.setOtpCode(null);
        user.setOtpExpiredAt(null);

        userRepository.save(user);

        return "Account verified successfully.";
    }

    /*
     * Resend OTP
     */
    public String resendOtp(String email) {

        Users user = userRepository.findByEmail(email)
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found"));

        if (Boolean.TRUE.equals(user.getVerified())) {
            throw new BadRequestException("Account is already verified.");
        }

        user.setOtpCode(otpGenerator.generateOtp());
        user.setOtpExpiredAt(
                LocalDateTime.now().plusMinutes(5));

        userRepository.save(user);


        // Send Email
        emailService.sendOtpEmail(
                user.getEmail(),
                user.getOtpCode());
        return "OTP has been resent.";
    }

    /*
     * Forgot Password
     */
    public String forgotPassword(ForgotPasswordRequest request) {

        Users user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found"));

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
    public String resetPassword(
            ResetPasswordRequest request) {

        Users user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found"));

        if (user.getOtpCode() == null || !user.getOtpCode().equals(request.getOtpCode())) {
            throw new BadRequestException("OTP invalid.");
        }

        if (user.getOtpExpiredAt() == null || user.getOtpExpiredAt().isBefore(LocalDateTime.now())) {
            throw new BadRequestException("OTP expired.");
        }

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

            throw new BadRequestException("Current password incorrect.");
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
    public String logout() {

        return "Logout successful.";
    }

}
