package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.Goals;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface GoalRepository extends JpaRepository<Goals, Long> {

    List<Goals> findByUserId(Long userId);

    List<Goals> findByCompleted(Boolean completed);

    List<Goals> findByArchived(Boolean archived);

}