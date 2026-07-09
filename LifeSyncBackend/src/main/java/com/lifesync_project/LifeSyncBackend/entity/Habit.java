package com.lifesync_project.LifeSyncBackend.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "habits")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Habit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user_id;

    private String title;

    private String description;

    private String category;

    private TargetFrequency target_frequency;

    private LocalTime reminder_time;

    @Builder.Default
    private Boolean status = true;

    private LocalDateTime created_at;

    private LocalDateTime updated_at;

    public enum TargetFrequency {
        daily, weekly, monthly
    }
}


