package com.lifesync_project.LifeSyncBackend.dto.FlashcardDeck;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FlashcardDeckResponse {

    private Long id;

    private Long userId;

    private String title;

    private String description;

    private LocalDateTime createdAt;
}
