package com.lifesync_project.LifeSyncBackend.dto.WeeklyReview;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class WeeklyReviewRequest {

    private Long userId;

    @NotBlank
    @Size(max = 5000)
    private String reviewSummary;

    @NotNull
    private LocalDateTime startDate;

    @NotNull
    private LocalDateTime endDate;
}
