package com.lifesync_project.LifeSyncBackend.dto.Auth;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ChangePasswordRequest {

    @NotBlank
    private String currentPassword;

    @NotBlank
    @Size(min = 12, max = 100, message = "Password must contain 12-100 characters")
    @Pattern(regexp = "(?s)^(?=.*[0-9])(?=.*[\\x21-\\x2F\\x3A-\\x40\\x5B-\\x60\\x7B-\\x7E]).*$", message = "Password must contain a number and a symbol")
    private String newPassword;
}
