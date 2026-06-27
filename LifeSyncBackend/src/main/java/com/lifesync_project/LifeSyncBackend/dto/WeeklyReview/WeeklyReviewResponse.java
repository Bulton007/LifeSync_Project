package com.lifesync_project.LifeSyncBackend.dto.WeeklyReview;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WeeklyReviewResponse {

    private Long id;

    private Long userId;

    private String reviewSummary;

    private LocalDateTime startDate;

    private LocalDateTime endDate;

    private LocalDateTime createdAt;
}
