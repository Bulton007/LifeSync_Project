package com.lifesync_project.LifeSyncBackend.dto.Habit;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.LocalDate;

@Data
public class HabitRequest {

    private Long userId;

    @NotBlank(message = "Habit name is required")
    private String name;

    private String description;

    private String frequency;

    private LocalDate startDate;

    private LocalDate endDate;

}