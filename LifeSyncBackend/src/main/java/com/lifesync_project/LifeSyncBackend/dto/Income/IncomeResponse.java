package com.lifesync_project.LifeSyncBackend.dto.Income;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
public class IncomeResponse {

    private Long id;

    private Long userId;

    private Long categoryId;

    private String title;

    private String description;

    private BigDecimal amount;

    private LocalDate incomeDate;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

}