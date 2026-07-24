package com.lifesync_project.LifeSyncBackend.dto.GoalSchedule;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class GoalScheduleRequest {

    @NotNull
    private Long goalId;

    @NotNull
    private LocalDate scheduleDate;

    @DecimalMin(value = "0.01")
    private BigDecimal amount;

}