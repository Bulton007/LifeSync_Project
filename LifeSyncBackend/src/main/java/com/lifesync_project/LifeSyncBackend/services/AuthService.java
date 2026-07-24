package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Auth.*;
import com.lifesync_project.LifeSyncBackend.dto.Auth.RegisterRequest;
import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.UserRepository;
import com.lifesync_project.LifeSyncBackend.security.JwtService;
import com.lifesync_project.LifeSyncBackend.utils.OtpGenerator;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Random;

@Service
@RequiredArgsConstructor
@Transactional
public class AuthService {

    private final EmailService emailService;

    private final OtpGenerator otpGenerator;
    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    /*
     * Register
     */
    public String register(RegisterRequest request) {

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already exists.");
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


        // Send OTP Email
//        emailService.sendOtpEmail(
//                user.getEmail(),
//                user.getOtpCode());

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

            throw new RuntimeException("Incorrect password.");
        }

        if (!user.getVerified()) {
            throw new RuntimeException("Account is not verified.");
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

        if (!user.getOtpCode().equals(request.getOtpCode())) {
            throw new RuntimeException("Invalid OTP.");
        }

        if (user.getOtpExpiredAt().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("OTP expired.");
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

        user.setOtpCode(generateOtp());
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

        user.setOtpCode(generateOtp());

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

        if (!user.getOtpCode().equals(request.getOtpCode())) {
            throw new RuntimeException("OTP invalid.");
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

        Users user = userRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found"));

        if (!passwordEncoder.matches(
                request.getCurrentPassword(),
                user.getPassword())) {

            throw new RuntimeException("Current password incorrect.");
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

    /*
     * Generate 6-digit OTP
     */
    private String generateOtp() {

        return String.valueOf(
                new Random().nextInt(900000) + 100000);
    }

}