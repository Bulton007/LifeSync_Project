package com.lifesync_project.LifeSyncBackend;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatRequest;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatResponse;
import com.lifesync_project.LifeSyncBackend.services.GeminiService;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class GeminiServiceTest {

    @Test
    void serviceGeneratesRealReplyWhenKeyIsAvailable() {
        String apiKey = System.getenv("GEMINI_API_KEY");
        if (apiKey == null || apiKey.isBlank()) {
            apiKey = System.getProperty("GEMINI_API_KEY", "");
        }
        if (apiKey.isBlank()) {
            System.out.println("Skipping live Gemini test because no key is configured in env.");
            return;
        }

        GeminiService service = new GeminiService(
                apiKey,
                "https://generativelanguage.googleapis.com/v1beta",
                "gemini-3.6-flash",
                new ObjectMapper()
        );

        AiChatResponse response = service.chat(AiChatRequest.builder()
                .prompt("Say hello from LifeSync test")
                .build());

        assertThat(response).isNotNull();
        assertThat(response.getReply()).isNotBlank();
        assertThat(response.getModel()).isNotBlank();
        System.out.println("=== LIVE GEMINI TEST SUCCESSFUL ===");
        System.out.println("Model: " + response.getModel());
        System.out.println("Reply: " + response.getReply());
    }
}
