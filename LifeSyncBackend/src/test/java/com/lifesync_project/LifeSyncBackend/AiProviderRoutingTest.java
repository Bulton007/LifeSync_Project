package com.lifesync_project.LifeSyncBackend;

import com.lifesync_project.LifeSyncBackend.controller.AiAssistantController;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatRequest;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatResponse;
import com.lifesync_project.LifeSyncBackend.services.GeminiService;
import com.lifesync_project.LifeSyncBackend.services.OpenRouterService;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class AiProviderRoutingTest {
    @Test
    void openRouterRoutesWithoutCallingGemini() {
        var gemini = mock(GeminiService.class);
        var router = mock(OpenRouterService.class);
        var controller = new AiAssistantController(gemini, router);
        ReflectionTestUtils.setField(controller, "provider", "openrouter");
        var request = AiChatRequest.builder().prompt("Help plan my day").build();
        var reply = new AiChatResponse("Start with one task.", "test/model");
        when(router.chat(request)).thenReturn(reply);
        assertSame(reply, controller.chat(request).getBody());
        verifyNoInteractions(gemini);
    }

    @Test
    void invalidProviderDoesNotSilentlySendDataElsewhere() {
        var gemini = mock(GeminiService.class);
        var router = mock(OpenRouterService.class);
        var controller = new AiAssistantController(gemini, router);
        ReflectionTestUtils.setField(controller, "provider", "typo");
        assertThrows(IllegalStateException.class, () -> controller.chat(
                AiChatRequest.builder().prompt("Hello").build()));
        verifyNoInteractions(gemini, router);
    }
}
