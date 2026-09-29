package com.lifesync_project.LifeSyncBackend.dto.Auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResetPasswordRequest {

    @NotBlank
    @Email
    private String email;

    @NotBlank
    @Pattern(regexp = "^[0-9]{6}$", message = "OTP must contain exactly 6 digits")
    private String otpCode;

    @NotBlank
    @Size(min = 12, max = 100, message = "Password must contain 12-100 characters")
    @Pattern(regexp = "(?s)^(?=.*[0-9])(?=.*[\\x21-\\x2F\\x3A-\\x40\\x5B-\\x60\\x7B-\\x7E]).*$", message = "Password must contain a number and a symbol")
    private String newPassword;
}
