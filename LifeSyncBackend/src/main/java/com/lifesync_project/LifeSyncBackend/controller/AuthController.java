package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.Auth.ChangePasswordRequest;
import com.lifesync_project.LifeSyncBackend.dto.Auth.ForgotPasswordRequest;
import com.lifesync_project.LifeSyncBackend.dto.Auth.LoginRequest;
import com.lifesync_project.LifeSyncBackend.dto.Auth.LoginResponse;
import com.lifesync_project.LifeSyncBackend.dto.Auth.RegisterRequest;
import com.lifesync_project.LifeSyncBackend.dto.Auth.ResetPasswordRequest;
import com.lifesync_project.LifeSyncBackend.dto.Auth.VerifyOtpRequest;
import com.lifesync_project.LifeSyncBackend.services.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

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
            @RequestParam String email) {

        return ResponseEntity.ok(
                authService.resendOtp(email));
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