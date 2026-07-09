package com.lifesync_project.LifeSyncBackend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "goals")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Goal {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private String title;

    private BigDecimal targetAmount;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receiver_id") 
    @Builder.Default
    private BigDecimal currentAmount = BigDecimal.ZERO;

    private LocalDate deadline;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    private GoalStatus status = GoalStatus.pending;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    public enum GoalStatus {
        pending, success, failed
    }
}


