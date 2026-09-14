package com.lifesync_project.LifeSyncBackend.exception;

public class OtpLimitException extends RuntimeException {
    private final long retryAfterSeconds;

    public OtpLimitException(long retryAfterSeconds) {
        super("Too many OTP attempts. Try again in " + retryAfterSeconds + " seconds.");
        this.retryAfterSeconds = retryAfterSeconds;
    }

    public long getRetryAfterSeconds() {
        return retryAfterSeconds;
    }
}
