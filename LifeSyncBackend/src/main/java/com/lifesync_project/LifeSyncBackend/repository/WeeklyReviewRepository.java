package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.WeeklyReview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WeeklyReviewRepository
        extends JpaRepository<WeeklyReview, Long> {

    List<WeeklyReview> findByUserId(Long userId);
}
