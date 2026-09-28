package com.lifesync_project.LifeSyncBackend.services;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lifesync_project.LifeSyncBackend.exception.AiUnavailableException;
import com.lifesync_project.LifeSyncBackend.exception.GlobalExceptionHandler;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class OpenRouterResponseTest {
    private final ObjectMapper mapper = new ObjectMapper();

    @Test
    void readsAnswerText() throws Exception {
        assertEquals("Answer", OpenRouterService.responseText(mapper.readTree(
                "{\"choices\":[{\"message\":{\"content\":\" Answer \"}}]}")));
    }

    @Test
    void doesNotExposeReasoningAsAnAnswer() throws Exception {
        var response = mapper.readTree("{\"choices\":[{\"message\":{\"content\":null,\"reasoning\":\"private reasoning\"}}]}");
        var error = assertThrows(AiUnavailableException.class, () -> OpenRouterService.responseText(response));
        assertEquals(503, new GlobalExceptionHandler().handleAiUnavailable(error).getStatusCode().value());
    }

    @Test
    void rejectsMissingResponse() {
        assertThrows(AiUnavailableException.class, () -> OpenRouterService.responseText(null));
    }
}
