package com.lifesync_project.LifeSyncBackend.dto.Budget;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class BudgetRequest {

    @NotBlank
    private String category;

    @Positive
    private BigDecimal limitAmount;
}