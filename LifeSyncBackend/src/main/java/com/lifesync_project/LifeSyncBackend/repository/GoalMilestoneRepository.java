package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.dto.GoalMilestone.GoalMilestoneResponse;
import com.lifesync_project.LifeSyncBackend.entity.GoalMilestone;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface GoalMilestoneRepository extends JpaRepository<GoalMilestone, Long> {
    List<GoalMilestone> findByGoalId(Long goalId);
}
