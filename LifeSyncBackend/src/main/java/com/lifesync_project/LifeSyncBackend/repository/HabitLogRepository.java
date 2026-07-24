package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.HabitLogs;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface HabitLogRepository extends JpaRepository<HabitLogs, Long> {

    List<HabitLogs> findByHabitId(Long habitId);

    List<HabitLogs> findByUserId(Long userId);

    boolean existsByHabitIdAndCompletedDate(
            Long habitId,
            LocalDate completedDate);

}