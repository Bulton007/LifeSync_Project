package com.lifesync_project.LifeSyncBackend.dto.Users;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RegisterRequest {

    @NotBlank(message = "Full name is required")
    @Size(max = 100)
    private String fullName;

    @NotBlank(message = "Email is required")
    @Email
    private String email;

    @Pattern(
            regexp = "^[0-9]{8,15}$",
            message = "Phone number must contain 8-15 digits"
    )
    private String phoneNumber;

    @Pattern(
            regexp = "^[0-9]{10,12}$",
            message = "Telegram ID must contain 10-12 digits"
    )
    private String telegramId;

    @NotBlank(message = "Password is required")
    @Size(min = 12, max = 100, message = "Password must contain 12-100 characters")
    @Pattern(regexp = "(?s)^(?=.*[0-9])(?=.*[\\x21-\\x2F\\x3A-\\x40\\x5B-\\x60\\x7B-\\x7E]).*$", message = "Password must contain a number and a symbol")
    private String password;
}
