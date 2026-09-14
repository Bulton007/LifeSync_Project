package com.lifesync_project.LifeSyncBackend.services;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username:}")
    private String mailUsername;

    public void sendOtpEmail(
            String email,
            String otpCode) {

        if (mailUsername == null || mailUsername.isBlank()) {
            throw new IllegalStateException("Gmail sender username is not configured.");
        }

        SimpleMailMessage message =
                new SimpleMailMessage();

        message.setFrom(mailUsername);
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
        } catch (MailException exception) {
            log.warn("Failed to send OTP email to {}.", email, exception);
            throw new IllegalStateException("Failed to send OTP email. Check Gmail SMTP configuration.", exception);
        }
    }

}
