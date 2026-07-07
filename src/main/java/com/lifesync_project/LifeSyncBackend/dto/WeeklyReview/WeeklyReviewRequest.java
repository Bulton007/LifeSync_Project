package com.lifesync_project.LifeSyncBackend.dto.WeeklyReview;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class WeeklyReviewRequest {

    @NotNull
    private Long userId;

    @NotBlank
    private String reviewSummary;

    @NotNull
    private LocalDateTime startDate;

    @NotNull
    private LocalDateTime endDate;
}
