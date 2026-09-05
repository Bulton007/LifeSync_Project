package com.lifesync_project.LifeSyncBackend.services;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {

    private final JavaMailSender mailSender;

    public void sendOtpEmail(
            String email,
            String otpCode) {

        // Send asynchronously in background so the client receives responses instantly without waiting
        CompletableFuture.runAsync(() -> {
            SimpleMailMessage message =
                    new SimpleMailMessage();

            message.setTo(email);

            message.setSubject("LifeSync Email Verification");

            message.setText(
                    """
                    Welcome to LifeSync!

                    Your verification code is:

                    %s

                    This code will expire in 5 minutes.

                    Please do not share this code with anyone.
                    """.formatted(otpCode));

            try {
                mailSender.send(message);
                log.info("OTP email sent successfully to {}", email);
            } catch (MailException exception) {
                log.warn(
                        "Failed to send OTP email to {}. OTP for local testing: {}",
                        email,
                        otpCode,
                        exception);
            }
        });
    }

}
