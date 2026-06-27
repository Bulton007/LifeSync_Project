package com.lifesync_project.LifeSyncBackend.dto.FlashcardDeck;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FlashcardDeckRequest {

    @NotNull
    private Long userId;

    @NotBlank
    @Size(max = 255)
    private String title;

    @Size(max = 2000)
    private String description;
}
