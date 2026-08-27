package com.lifesync_project.LifeSyncBackend.services;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.client.RestClient;
import java.util.Map;


@Service
public class TelegramService {
    private final String telegramApiUrl;

    public TelegramService(@Value("${telegram.bot.api-url}") String telegramApiUrl) {
        this.telegramApiUrl = telegramApiUrl;
    }

    public boolean sendOtpMessage(String chatId, String otpCode) {
        String messageText = """
                Welcome to LifeSync!

                Your verification code is: *%s*

                This code will expire in 5 minutes.
                Please do not share this code with anyone.
                """.formatted(otpCode);

        try {
            return RestClient.builder()
                    .baseUrl(telegramApiUrl)
                    .build()
                    .post()
                    .uri("/sendMessage")
                    .body(Map.of(
                            "chat_id", chatId,
                            "text", messageText,
                            "parse_mode", "Markdown"
                    ))
                    .retrieve()
                    .toBodilessEntity()
                    .getStatusCode()
                    .is2xxSuccessful();
        } catch (Exception e) {
            return false;
        }
    }
}
