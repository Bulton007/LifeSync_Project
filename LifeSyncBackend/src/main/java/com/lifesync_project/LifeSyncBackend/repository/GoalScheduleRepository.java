package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.GoalSchedules;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface GoalScheduleRepository extends JpaRepository<GoalSchedules, Long> {

    List<GoalSchedules> findByGoalId(Long goalId);

}