package com.lifesync_project.LifeSyncBackend.dto.GoalSchedule;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
public class GoalScheduleResponse {

    private Long goalScheduleId;

    private Long goalId;

    private LocalDate scheduleDate;

    @JsonFormat(shape = JsonFormat.Shape.STRING)
    private BigDecimal amount;

    private Boolean completed;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

}
