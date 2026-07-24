package com.lifesync_project.LifeSyncBackend.dto.HabitLog;

import lombok.Data;

import java.time.LocalDate;

@Data
public class HabitLogRequest {

    private Long habitId;

    private Long userId;

    private LocalDate completedDate;

    private String note;

}