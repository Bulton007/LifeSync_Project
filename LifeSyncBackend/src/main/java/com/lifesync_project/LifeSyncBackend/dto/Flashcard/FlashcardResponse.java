package com.lifesync_project.LifeSyncBackend.dto.Flashcard;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FlashcardResponse {

    private Long id;

    private Long deckId;

    private String frontText;

    private String backText;

    private LocalDateTime createdAt;
}
