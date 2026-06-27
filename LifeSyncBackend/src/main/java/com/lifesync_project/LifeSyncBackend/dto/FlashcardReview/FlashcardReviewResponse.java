package com.lifesync_project.LifeSyncBackend.dto.FlashcardReview;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FlashcardReviewResponse {

    private Long id;

    private Long cardId;

    private Long userId;

    private Boolean known;

    private LocalDateTime reviewedAt;
}
