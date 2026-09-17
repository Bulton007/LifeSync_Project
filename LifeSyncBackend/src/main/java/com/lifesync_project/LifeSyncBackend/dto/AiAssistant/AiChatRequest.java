package com.lifesync_project.LifeSyncBackend.dto.AiAssistant;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AiChatRequest {

    @NotBlank(message = "Prompt cannot be blank")
    private String prompt;

    private List<AiChatMessageDto> history;
}
