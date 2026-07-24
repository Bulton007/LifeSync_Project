package com.lifesync_project.LifeSyncBackend.dto.Expense;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class ExpenseRequest {

    private Long userId;

    private Long categoryId;

    @NotBlank(message = "Expense title is required")
    private String title;

    private String description;

    @DecimalMin(value = "0.01", message = "Amount must be greater than 0")
    private BigDecimal amount;

    private LocalDate expenseDate;

}