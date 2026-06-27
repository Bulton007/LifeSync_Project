package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.FlashcardReview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FlashcardReviewRepository
        extends JpaRepository<FlashcardReview, Long> {

    List<FlashcardReview> findByUserId(Long userId);

    List<FlashcardReview> findByCardId(Long cardId);
}
