package com.lifesync_project.LifeSyncBackend;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatRequest;
import com.lifesync_project.LifeSyncBackend.dto.AiAssistant.AiChatResponse;
import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.repository.UserRepository;
import com.lifesync_project.LifeSyncBackend.security.JwtService;
import com.lifesync_project.LifeSyncBackend.services.GeminiService;
import jakarta.transaction.Transactional;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class AiAssistantControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtService jwtService;

    @MockBean
    private GeminiService geminiService;

    @Test
    void unauthenticatedRequestToChatEndpointReturnsUnauthorized() throws Exception {
        AiChatRequest request = AiChatRequest.builder()
                .prompt("Hello assistant")
                .build();

        mockMvc.perform(post("/api/assistant/chat")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void authenticatedRequestWithBlankPromptReturnsBadRequest() throws Exception {
        Users user = saveVerifiedUser("ai-test-blank@lifesync.test");
        String token = "Bearer " + jwtService.generateToken(user);

        AiChatRequest request = AiChatRequest.builder()
                .prompt("   ")
                .build();

        mockMvc.perform(post("/api/assistant/chat")
                        .header("Authorization", token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void authenticatedRequestWithValidPromptReturnsAiReply() throws Exception {
        Users user = saveVerifiedUser("ai-test-success@lifesync.test");
        String token = "Bearer " + jwtService.generateToken(user);

        when(geminiService.chat(any(AiChatRequest.class))).thenReturn(
                AiChatResponse.builder()
                        .reply("Here are three focus tips for today.")
                        .model("gemini-2.5-flash")
                        .build()
        );

        AiChatRequest request = AiChatRequest.builder()
                .prompt("How can I stay focused on my habits today?")
                .build();

        mockMvc.perform(post("/api/assistant/chat")
                        .header("Authorization", token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.reply").value("Here are three focus tips for today."))
                .andExpect(jsonPath("$.model").value("gemini-2.5-flash"));
    }

    private Users saveVerifiedUser(String email) {
        return userRepository.saveAndFlush(Users.builder()
                .fullName("AI Test User")
                .email(email)
                .password("dummy-password")
                .verified(true)
                .build());
    }
}
