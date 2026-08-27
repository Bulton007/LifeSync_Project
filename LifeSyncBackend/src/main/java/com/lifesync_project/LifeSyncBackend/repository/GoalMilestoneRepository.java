package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.GoalMilestone;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface GoalMilestoneRepository extends JpaRepository<GoalMilestone, Long> {
    List<GoalMilestone> findByGoalId(Long goalId);

    List<GoalMilestone> findAllByGoalIdOrderByTargetDateAsc(Long goalId);

    Optional<GoalMilestone> findByIdAndGoalId(Long id, Long goalId);

    void deleteByGoalId(Long goalId);
}
