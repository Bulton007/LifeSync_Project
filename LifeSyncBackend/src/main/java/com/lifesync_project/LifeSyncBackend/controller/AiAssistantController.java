package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatRequest;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatResponse;
import com.lifesync_project.LifeSyncBackend.services.GeminiService;
import com.lifesync_project.LifeSyncBackend.services.OpenRouterService;
import org.springframework.beans.factory.annotation.Value;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/assistant")
@RequiredArgsConstructor
public class AiAssistantController {

    private final GeminiService geminiService;
    private final OpenRouterService openRouterService;
    @Value("${AI_PROVIDER:openrouter}")
    private String provider;

    @PostMapping("/chat")
    public ResponseEntity<AiChatResponse> chat(@Valid @RequestBody AiChatRequest request) {
        if ("openrouter".equalsIgnoreCase(provider)) {
            return ResponseEntity.ok(openRouterService.chat(request));
        }
        if ("gemini".equalsIgnoreCase(provider)) {
            return ResponseEntity.ok(geminiService.chat(request));
        }
        throw new IllegalStateException("Unsupported AI provider configured on the server.");
    }
}
