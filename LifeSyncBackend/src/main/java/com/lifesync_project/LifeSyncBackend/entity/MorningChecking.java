package com.lifesync_project.LifeSyncBackend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "morning_checkings")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MorningChecking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long userId;

    @Column(nullable = false)
    private Integer moodRating;

    @Column(columnDefinition = "TEXT")
    private String notes;

    private LocalDateTime checkedInAt;

    @PrePersist
    void prePersist() {
        if (checkedInAt == null) {
            checkedInAt = LocalDateTime.now();
        }
    }
}
