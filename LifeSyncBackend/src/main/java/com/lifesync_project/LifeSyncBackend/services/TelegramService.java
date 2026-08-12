package com.lifesync_project.LifeSyncBackend.services;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.client.RestClient;
import java.util.Map;


@Service
@RequiredArgsConstructor
public class TelegramService {
    private final RestClient restClient;

    public TelegramService(@Value("${telegram.bot.api-url}") String telegramApiUrl) {
        this.restClient = RestClient.builder()
                .baseUrl(telegramApiUrl)
                .build();
    }

    public boolean sendOtpMessage(String chatId, String otpCode) {
        String messageText = """
                Welcome to LifeSync!

                Your verification code is: *%s*

                This code will expire in 5 minutes.
                Please do not share this code with anyone.
                """.formatted(otpCode);

        try {
            return restClient.post()
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
