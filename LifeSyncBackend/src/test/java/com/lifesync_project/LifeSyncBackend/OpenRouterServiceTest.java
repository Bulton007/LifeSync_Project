package com.lifesync_project.LifeSyncBackend;

import com.lifesync_project.LifeSyncBackend.services.OpenRouterService;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatRequest;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertThrows;

class OpenRouterServiceTest {
    @Test
    void missingConfigurationFailsWithoutCallingProvider() {
        var request = AiChatRequest.builder().prompt("Hello").build();
        assertThrows(IllegalStateException.class,
                () -> new OpenRouterService("", "some/model").chat(request));
        assertThrows(IllegalStateException.class,
                () -> new OpenRouterService("not-a-real-key", "").chat(request));
    }
}
