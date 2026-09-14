package com.lifesync_project.LifeSyncBackend;

import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.exception.BadRequestException;
import com.lifesync_project.LifeSyncBackend.exception.OtpLimitException;
import com.lifesync_project.LifeSyncBackend.services.OtpPolicy;
import java.time.LocalDateTime;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class OtpPolicyTest {
    private final OtpPolicy policy = new OtpPolicy();
    private final LocalDateTime now = LocalDateTime.of(2026, 9, 10, 12, 0);

    @Test
    void fiveFailuresBlockBothChannelsAndInvalidateCode() {
        Users user = Users.builder().otpCode("123456").otpPurpose("registration")
                .otpExpiredAt(now.plusMinutes(5)).build();
        for (int attempt = 0; attempt < 4; attempt++) {
            assertThrows(BadRequestException.class, () -> policy.verify(user, "000000", "registration", now));
        }
        assertThrows(OtpLimitException.class, () -> policy.verify(user, "000000", "registration", now));
        assertEquals(now.plusMinutes(15), user.getOtpBlockedUntil());
        assertNull(user.getOtpCode());
        assertThrows(OtpLimitException.class, () -> policy.send(user, false, now.plusMinutes(14)));
        assertThrows(OtpLimitException.class, () -> policy.send(user, true, now.plusMinutes(14)));
        assertDoesNotThrow(() -> policy.send(user, false, now.plusMinutes(15)));
    }

    @Test
    void resendingDoesNotResetIncorrectAttempts() {
        Users user = Users.builder().otpFailures(4).build();
        policy.send(user, false, now);
        assertThrows(OtpLimitException.class, () -> policy.verify(user, "000000", "registration", now));
    }

    @Test
    void telegramRequiresThreeEmailResendsAndSharesSendLimit() {
        Users user = new Users();
        assertThrows(BadRequestException.class, () -> policy.send(user, true, now));
        for (int attempt = 0; attempt < 3; attempt++) policy.send(user, false, now.plusMinutes(attempt));
        policy.send(user, true, now.plusMinutes(3));
        policy.send(user, true, now.plusMinutes(4));
        assertThrows(OtpLimitException.class, () -> policy.send(user, false, now.plusMinutes(5)));
    }

    @Test
    void wrongPurposeCannotVerifyAccount() {
        Users user = Users.builder().otpCode("123456").otpPurpose("reset")
                .otpExpiredAt(now.plusMinutes(5)).build();
        assertThrows(BadRequestException.class, () -> policy.verify(user, "123456", "registration", now));
    }

    @Test
    void resendCooldownDoesNotExtendToFifteenMinuteBlock() {
        Users user = new Users();
        policy.send(user, false, now);
        assertThrows(OtpLimitException.class, () -> policy.send(user, false, now.plusSeconds(59)));
        assertNull(user.getOtpBlockedUntil());
        assertDoesNotThrow(() -> policy.send(user, false, now.plusSeconds(60)));
    }
}
