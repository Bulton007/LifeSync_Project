package com.lifesync_project.LifeSyncBackend.dto.Goal;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class GoalRequest {

    private Long userId;

    @NotBlank(message = "Goal title is required")
    private String title;

    private String description;

    @DecimalMin(value = "0.01")
    @NotNull(message = "Target amount is required")
    private BigDecimal targetAmount;

    @DecimalMin(value = "0.00")
    private BigDecimal currentAmount;

    @Future(message = "Deadline must be in the future")
    @NotNull(message = "Deadline is required")
    private LocalDate deadline;

}
