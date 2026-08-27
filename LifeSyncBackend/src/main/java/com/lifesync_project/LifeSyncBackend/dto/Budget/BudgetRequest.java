package com.lifesync_project.LifeSyncBackend.dto.Budget;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class BudgetRequest {

    @NotBlank
    private String category;

    @NotNull
    private Long categoryId;

    @Positive
    @NotNull
    private BigDecimal limitAmount;
}
