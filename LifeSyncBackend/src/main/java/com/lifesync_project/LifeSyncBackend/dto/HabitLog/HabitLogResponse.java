package com.lifesync_project.LifeSyncBackend.dto.HabitLog;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
public class HabitLogResponse {

    private Long habitLogId;

    private Long habitId;

    private Long userId;

    private LocalDate completedDate;

    private Boolean completed;

    private String note;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

}