package com.lifesync_project.LifeSyncBackend.dto.Goal;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
public class GoalResponse {

    private Long id;

    private Long userId;

    private String title;

    private String description;

    private BigDecimal targetAmount;

    private BigDecimal currentAmount;

    private Boolean completed;

    private Boolean archived;

    private LocalDate deadline;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

}