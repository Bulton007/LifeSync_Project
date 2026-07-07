package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.FlashcardDeck;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FlashcardDeckRepository
        extends JpaRepository<FlashcardDeck, Long> {

    List<FlashcardDeck> findByUserId(Long userId);
}
