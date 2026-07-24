package com.lifesync_project.LifeSyncBackend.services;

import lombok.RequiredArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    public void sendOtpEmail(
            String email,
            String otpCode) {

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

        mailSender.send(message);
    }

}