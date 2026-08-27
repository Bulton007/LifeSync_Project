package com.lifesync_project.LifeSyncBackend.dto.Income;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class IncomeRequest {

    private Long userId;

    @NotNull(message = "Category is required")
    private Long categoryId;

    @NotBlank(message = "Title is required")
    private String title;

    private String description;

    @DecimalMin(value = "0.01")
    @NotNull(message = "Amount is required")
    private BigDecimal amount;

    @NotNull(message = "Income date is required")
    private LocalDate incomeDate;

}
