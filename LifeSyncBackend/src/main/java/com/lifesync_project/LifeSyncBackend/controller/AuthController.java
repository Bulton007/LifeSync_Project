package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.Auth.ChangePasswordRequest;
import com.lifesync_project.LifeSyncBackend.dto.Auth.ForgotPasswordRequest;
import com.lifesync_project.LifeSyncBackend.dto.Auth.LoginRequest;
import com.lifesync_project.LifeSyncBackend.dto.Auth.LoginResponse;
import com.lifesync_project.LifeSyncBackend.dto.Users.RegisterRequest;
import com.lifesync_project.LifeSyncBackend.dto.Auth.ResetPasswordRequest;
import com.lifesync_project.LifeSyncBackend.dto.Auth.VerifyOtpRequest;
import com.lifesync_project.LifeSyncBackend.services.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    public record TelegramLinkRequest(
            @jakarta.validation.constraints.NotBlank
            @jakarta.validation.constraints.Pattern(regexp = "[1-9][0-9]{0,18}") String chatId) {}

    public record TelegramLinkVerification(
            @jakarta.validation.constraints.NotBlank
            @jakarta.validation.constraints.Pattern(regexp = "[0-9]{6}") String otpCode) {}

    @PostMapping("/telegram/link")
    public ResponseEntity<String> linkTelegram(@Valid @RequestBody TelegramLinkRequest request) {
        return ResponseEntity.ok(authService.linkTelegram(request.chatId()));
    }

    @PostMapping("/telegram/confirm")
    public ResponseEntity<String> confirmTelegram(@Valid @RequestBody TelegramLinkVerification request) {
        return ResponseEntity.ok(authService.confirmTelegram(request.otpCode()));
    }

    private final AuthService authService;

    /*
     * Check Email Exists
     */
    @GetMapping("/check-email")
    public ResponseEntity<Map<String, Object>> checkEmail(
            @RequestParam String email) {
        boolean exists = authService.checkEmailExists(email);
        return ResponseEntity.ok(Map.of(
                "email", email,
                "exists", exists
        ));
    }

    /*
     * Register
     */
    @PostMapping("/register")
    public ResponseEntity<String> register(
            @Valid @RequestBody RegisterRequest request) {

        return ResponseEntity.ok(
                authService.register(request));
    }

    /*
     * Login
     */
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(
            @Valid @RequestBody LoginRequest request) {

        return ResponseEntity.ok(
                authService.login(request));
    }

    /*
     * Verify OTP
     */
    @PostMapping("/verify-otp")
    public ResponseEntity<String> verifyOtp(
            @Valid @RequestBody VerifyOtpRequest request) {

        return ResponseEntity.ok(
                authService.verifyOtp(request));
    }

    /*
     * Resend OTP
     */
    @PostMapping("/resend-otp")
    public ResponseEntity<String> resendOtp(
            @RequestParam String email,
            @RequestParam(defaultValue = "email") String channel) {

        return ResponseEntity.ok(
                authService.resendOtp(email, channel));
    }

    /*
     * Forgot Password
     */
    @PostMapping("/forgot-password")
    public ResponseEntity<String> forgotPassword(
            @Valid @RequestBody ForgotPasswordRequest request) {

        return ResponseEntity.ok(
                authService.forgotPassword(request));
    }

    /*
     * Reset Password
     */
    @PostMapping("/reset-password")
    public ResponseEntity<String> resetPassword(
            @Valid @RequestBody ResetPasswordRequest request) {

        return ResponseEntity.ok(
                authService.resetPassword(request));
    }

    /*
     * Change Password
     */
    @PutMapping("/change-password/{id}")
    public ResponseEntity<String> changePassword(
            @PathVariable Long id,
            @Valid @RequestBody ChangePasswordRequest request) {

        return ResponseEntity.ok(
                authService.changePassword(id, request));
    }

    /*
     * Logout
     */
    @PostMapping("/logout")
    public ResponseEntity<String> logout() {

        return ResponseEntity.ok(
                authService.logout());
    }

}
