package com.lifesync_project.LifeSyncBackend.dto.Budget;

import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BudgetResponse {

    private Long id;

    private String category;

    private BigDecimal limitAmount;

    private BigDecimal spentAmount;

    private BigDecimal remainingAmount;
}