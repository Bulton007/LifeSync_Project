package com.lifesync_project.LifeSyncBackend.entity;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
@Entity
@Table(name = "budgets")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Budgets {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "category_id")
    private Long categoryId;

    private String category;

    @Column(precision = 12, scale = 2)
    private BigDecimal limitAmount;

    @Column(precision = 12, scale = 2)
    private BigDecimal spentAmount;
}
