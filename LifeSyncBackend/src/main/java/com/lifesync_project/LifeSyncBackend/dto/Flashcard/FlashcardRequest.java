package com.lifesync_project.LifeSyncBackend.dto.Flashcard;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FlashcardRequest {

    @NotNull
    private Long deckId;

    @NotBlank
    private String frontText;

    @NotBlank
    private String backText;
}
