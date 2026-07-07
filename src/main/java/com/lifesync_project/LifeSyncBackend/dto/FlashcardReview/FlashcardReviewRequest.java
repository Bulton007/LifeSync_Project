package com.lifesync_project.LifeSyncBackend.dto.FlashcardReview;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FlashcardReviewRequest {

    @NotNull
    private Long cardId;

    @NotNull
    private Long userId;

    @NotNull
    private Boolean known;
}
