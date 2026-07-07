package com.lifesync_project.LifeSyncBackend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "flashcard_reviews")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FlashcardReview {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "card_id", nullable = false)
    private Flashcard card;

    @Column(nullable = false)
    private Long userId;

    @Column(name = "is_known", nullable = false)
    private Boolean known;

    private LocalDateTime reviewedAt;

    @PrePersist
    void prePersist() {
        if (reviewedAt == null) {
            reviewedAt = LocalDateTime.now();
        }
    }
}
