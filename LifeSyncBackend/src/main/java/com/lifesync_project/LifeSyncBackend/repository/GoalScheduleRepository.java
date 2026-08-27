package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.GoalSchedules;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface GoalScheduleRepository extends JpaRepository<GoalSchedules, Long> {

    List<GoalSchedules> findByGoalId(Long goalId);

    List<GoalSchedules> findAllByGoalIdOrderByScheduleDateAsc(Long goalId);

    Optional<GoalSchedules> findByGoalScheduleIdAndGoalId(Long scheduleId, Long goalId);

    void deleteByGoalId(Long goalId);

}
