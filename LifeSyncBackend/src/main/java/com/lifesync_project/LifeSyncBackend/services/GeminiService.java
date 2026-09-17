package com.lifesync_project.LifeSyncBackend.services;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatMessageDto;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatRequest;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class GeminiService {

    private final String apiKey;
    private final String apiBaseUrl;
    private final String preferredModel;
    private final RestClient restClient;
    private final ObjectMapper objectMapper;

    public GeminiService(
            @Value("${gemini.api.key:}") String apiKey,
            @Value("${gemini.api.url:https://generativelanguage.googleapis.com/v1beta}") String apiBaseUrl,
            @Value("${gemini.model:gemini-3.6-flash}") String preferredModel,
            ObjectMapper objectMapper) {
        this.apiKey = apiKey != null ? apiKey.trim() : "";
        this.apiBaseUrl = apiBaseUrl != null && !apiBaseUrl.isBlank()
                ? apiBaseUrl.replaceAll("/+$", "")
                : "https://generativelanguage.googleapis.com/v1beta";
        this.preferredModel = preferredModel != null && !preferredModel.isBlank()
                ? preferredModel.trim()
                : "gemini-3.6-flash";
        this.objectMapper = objectMapper;

        SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
        requestFactory.setConnectTimeout(15000);
        requestFactory.setReadTimeout(60000);

        this.restClient = RestClient.builder()
                .requestFactory(requestFactory)
                .build();
    }

    public AiChatResponse chat(AiChatRequest request) {
        if (apiKey.isEmpty()) {
            throw new IllegalStateException("Gemini API key is not configured on the backend server.");
        }

        List<Map<String, Object>> contents = new ArrayList<>();

        if (request.getHistory() != null) {
            int start = Math.max(0, request.getHistory().size() - 8);
            for (int i = start; i < request.getHistory().size(); i++) {
                AiChatMessageDto msg = request.getHistory().get(i);
                if (msg.getText() != null && !msg.getText().isBlank()) {
                    String role = "model".equalsIgnoreCase(msg.getRole()) || "assistant".equalsIgnoreCase(msg.getRole())
                            ? "model"
                            : "user";
                    contents.add(Map.of(
                            "role", role,
                            "parts", List.of(Map.of("text", msg.getText()))
                    ));
                }
            }
        }

        contents.add(Map.of(
                "role", "user",
                "parts", List.of(Map.of("text", request.getPrompt().trim()))
        ));

        Map<String, Object> payload = new HashMap<>();
        payload.put("system_instruction", Map.of(
                "parts", List.of(Map.of("text",
                        "You are LifeSync AI, a friendly, encouraging, and intelligent personal productivity companion for the LifeSync app. " +
                                "You help users organize tasks, build positive habits, achieve goals, manage budget/finances, and practice mindful journaling. " +
                                "Keep your answers concise, practical, engaging, and clear. Format responses with neat bullet points or short paragraphs where appropriate."
                ))
        ));
        payload.put("contents", contents);
        payload.put("generationConfig", Map.of(
                "temperature", 0.7,
                "maxOutputTokens", 1024
        ));

        List<String> modelsToTry = List.of(
                preferredModel,
                "gemini-3.6-flash",
                "gemini-flash-latest",
                "gemini-2.5-flash-lite",
                "gemini-3.5-flash",
                "gemini-3.5-flash-lite"
        );

        Exception lastException = null;

        for (String model : modelsToTry) {
            try {
                String url = apiBaseUrl + "/models/" + model + ":generateContent";

                String rawResponse = restClient.post()
                        .uri(url)
                        .header("x-goog-api-key", apiKey)
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(payload)
                        .retrieve()
                        .body(String.class);

                if (rawResponse == null || rawResponse.isBlank()) {
                    continue;
                }

                JsonNode root = objectMapper.readTree(rawResponse);
                JsonNode candidates = root.path("candidates");
                if (candidates.isArray() && !candidates.isEmpty()) {
                    JsonNode parts = candidates.get(0).path("content").path("parts");
                    if (parts.isArray() && !parts.isEmpty()) {
                        String reply = parts.get(0).path("text").asText("");
                        if (!reply.isBlank()) {
                            return AiChatResponse.builder()
                                    .reply(reply.trim())
                                    .model(model)
                                    .build();
                        }
                    }
                }
            } catch (Exception e) {
                log.warn("Gemini model {} failed: {}", model, e.getMessage());
                lastException = e;
            }
        }

        throw new RuntimeException("Failed to generate AI response from Gemini: " +
                (lastException != null ? lastException.getMessage() : "empty response"));
    }
}
