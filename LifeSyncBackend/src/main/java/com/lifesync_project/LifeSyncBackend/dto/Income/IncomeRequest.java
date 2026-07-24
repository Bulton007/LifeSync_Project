package com.lifesync_project.LifeSyncBackend.dto.Income;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class IncomeRequest {

    private Long userId;

    private Long categoryId;

    @NotBlank(message = "Title is required")
    private String title;

    private String description;

    @DecimalMin(value = "0.01")
    private BigDecimal amount;

    private LocalDate incomeDate;

}