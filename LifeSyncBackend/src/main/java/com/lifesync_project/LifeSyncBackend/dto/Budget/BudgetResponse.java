package com.lifesync_project.LifeSyncBackend.dto.Budget;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BudgetResponse {

    private Long id;

    private Long userId;

    private Long categoryId;

    private String category;

    @JsonFormat(shape = JsonFormat.Shape.STRING)
    private BigDecimal limitAmount;

    @JsonFormat(shape = JsonFormat.Shape.STRING)
    private BigDecimal spentAmount;

    @JsonFormat(shape = JsonFormat.Shape.STRING)
    private BigDecimal remainingAmount;
}
