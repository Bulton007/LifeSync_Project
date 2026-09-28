package com.lifesync_project.LifeSyncBackend.services;

import com.fasterxml.jackson.databind.JsonNode;
import com.lifesync_project.LifeSyncBackend.exception.AiUnavailableException;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatRequest;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class OpenRouterService {
    private final String apiKey;
    private final String model;
    private final RestClient client;

    public OpenRouterService(
            @Value("${OPENROUTER_API_KEY:}") String apiKey,
            @Value("${OPENROUTER_MODEL:}") String model) {
        this.apiKey = apiKey.trim();
        this.model = model.trim();
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(15000);
        factory.setReadTimeout(60000);
        this.client = RestClient.builder().requestFactory(factory)
                .baseUrl("https://openrouter.ai/api/v1").build();
    }

    public AiChatResponse chat(AiChatRequest request) {
        if (apiKey.isEmpty() || model.isEmpty()) {
            throw new IllegalStateException("OpenRouter key and model must be configured on the server.");
        }
        List<Map<String, String>> messages = new ArrayList<>();
        messages.add(Map.of("role", "system", "content",
                "You are LifeSync's productivity assistant. Give concise, practical answers in the user's language, including Khmer. Do not claim to modify app data."));
        if (request.getHistory() != null) {
            var history = request.getHistory();
            for (int index = Math.max(0, history.size() - 8); index < history.size(); index++) {
                var message = history.get(index);
                if (message.getText() == null || message.getText().isBlank()) continue;
                String role = "model".equalsIgnoreCase(message.getRole()) || "assistant".equalsIgnoreCase(message.getRole())
                        ? "assistant" : "user";
                messages.add(Map.of("role", role, "content", message.getText()));
            }
        }
        messages.add(Map.of("role", "user", "content", request.getPrompt().trim()));
        try {
            JsonNode response = client.post().uri("/chat/completions")
                    .headers(headers -> headers.setBearerAuth(apiKey))
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(Map.of("model", model, "messages", messages, "max_tokens", 1024, "stream", false))
                    .retrieve().body(JsonNode.class);
            return new AiChatResponse(responseText(response), model);
        } catch (RestClientException error) {
            throw new IllegalStateException("OpenRouter is unavailable. Check server credentials, model access, and account credit.");
        }
    }

    static String responseText(JsonNode response) {
        JsonNode choice = response == null ? null : response.path("choices").path(0);
        String reply = choice == null ? "" : choice.path("message").path("content").asText("");
        if (reply.isBlank()) {
            throw new AiUnavailableException("The AI service returned no answer. Please try again shortly.");
        }
        return reply.trim();
    }
}
