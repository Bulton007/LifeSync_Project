package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.exception.BadRequestException;
import com.lifesync_project.LifeSyncBackend.exception.OtpLimitException;
import java.time.Duration;
import java.time.LocalDateTime;
import org.springframework.stereotype.Component;

@Component
public class OtpPolicy {
    public void check(Users user, LocalDateTime now) {
        if (user.getOtpBlockedUntil() != null && now.isBefore(user.getOtpBlockedUntil())) {
            throw new OtpLimitException(Math.max(1, Duration.between(now, user.getOtpBlockedUntil()).toSeconds()));
        }
        if (user.getOtpBlockedUntil() != null) {
            clear(user);
            user.setOtpBlockedUntil(null);
            user.setOtpLastSentAt(null);
        }
        if (user.getOtpWindowStartedAt() == null || !now.isBefore(user.getOtpWindowStartedAt().plusMinutes(15))) {
            user.setOtpWindowStartedAt(now);
            user.setOtpEmailAttempts(0);
            user.setOtpSendAttempts(0);
        }
    }

    public void send(Users user, boolean telegram, LocalDateTime now) {
        check(user, now);
        if (user.getOtpLastSentAt() != null && now.isBefore(user.getOtpLastSentAt().plusSeconds(60))) {
            throw new OtpLimitException(Math.max(1, Duration.between(now, user.getOtpLastSentAt().plusSeconds(60)).toSeconds()));
        }
        if (count(user.getOtpSendAttempts()) >= 5) {
            block(user, now);
        }
        if (telegram && count(user.getOtpEmailAttempts()) < 3) {
            throw new BadRequestException("Try Gmail resend three times before Telegram.");
        }
        user.setOtpSendAttempts(count(user.getOtpSendAttempts()) + 1);
        if (!telegram) user.setOtpEmailAttempts(count(user.getOtpEmailAttempts()) + 1);
        user.setOtpLastSentAt(now);
    }

    public void verify(Users user, String code, String purpose, LocalDateTime now) {
        check(user, now);
        if (!purpose.equals(user.getOtpPurpose()) || user.getOtpCode() == null
                || !user.getOtpCode().equals(code) || user.getOtpExpiredAt() == null
                || !now.isBefore(user.getOtpExpiredAt())) {
            user.setOtpFailures(count(user.getOtpFailures()) + 1);
            if (user.getOtpFailures() >= 5) block(user, now);
            throw new BadRequestException("Invalid or expired OTP.");
        }
        clear(user);
    }

    private void block(Users user, LocalDateTime now) {
        user.setOtpBlockedUntil(now.plusMinutes(15));
        user.setOtpCode(null);
        user.setOtpExpiredAt(null);
        throw new OtpLimitException(900);
    }

    private void clear(Users user) {
        user.setOtpFailures(0);
        user.setOtpEmailAttempts(0);
        user.setOtpSendAttempts(0);
        user.setOtpWindowStartedAt(null);
        user.setOtpCode(null);
        user.setOtpExpiredAt(null);
        user.setOtpPurpose(null);
    }

    private int count(Integer value) {
        return value == null ? 0 : value;
    }
}
