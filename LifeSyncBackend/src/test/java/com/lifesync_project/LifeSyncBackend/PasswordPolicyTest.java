package com.lifesync_project.LifeSyncBackend;

import com.lifesync_project.LifeSyncBackend.dto.Users.RegisterRequest;
import com.lifesync_project.LifeSyncBackend.dto.Auth.ResetPasswordRequest;
import com.lifesync_project.LifeSyncBackend.dto.Auth.ChangePasswordRequest;
import jakarta.validation.Validation;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class PasswordPolicyTest {
    @Test
    void enforcesPolicyOnEveryNewPasswordEndpoint() {
        try (var factory = Validation.buildDefaultValidatorFactory()) {
            var validator = factory.getValidator();
            for (var request : new Class<?>[]{RegisterRequest.class, ResetPasswordRequest.class, ChangePasswordRequest.class}) {
                var property = request == RegisterRequest.class ? "password" : "newPassword";
                assertTrue(validator.validateValue(request, property, "abcdefghij1!").isEmpty());
                for (var invalid : new String[]{"short1!", "abcdefghijkl!", "abcdefghijk12", "abcdefghij1 ", "a".repeat(101)}) {
                    assertFalse(validator.validateValue(request, property, invalid).isEmpty());
                }
            }
        }
    }
}
