package com.lifesync_project.LifeSyncBackend.dto.HabitLog;

import lombok.Data;

import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;

@Data
public class HabitLogRequest {

    @NotNull(message = "Habit is required")
    private Long habitId;

    private Long userId;

    @NotNull(message = "Completion date is required")
    private LocalDate completedDate;

    private String note;

}
