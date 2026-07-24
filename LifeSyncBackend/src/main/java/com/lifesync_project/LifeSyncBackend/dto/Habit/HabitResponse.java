package com.lifesync_project.LifeSyncBackend.dto.Habit;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
public class HabitResponse {

    private Long habitId;

    private Long userId;

    private String name;

    private String description;

    private String frequency;

    private Integer streak;

    private Boolean active;

    private LocalDate startDate;

    private LocalDate endDate;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

}