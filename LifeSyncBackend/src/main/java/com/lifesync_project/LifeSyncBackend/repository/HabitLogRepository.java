package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.HabitLogs;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface HabitLogRepository extends JpaRepository<HabitLogs, Long> {

    List<HabitLogs> findByHabitId(Long habitId);

    List<HabitLogs> findByUserId(Long userId);

    List<HabitLogs> findAllByUserIdOrderByCompletedDateDesc(Long userId);

    List<HabitLogs> findAllByHabitIdAndUserIdOrderByCompletedDateDesc(
            Long habitId,
            Long userId);

    Optional<HabitLogs> findByHabitLogIdAndUserId(Long habitLogId, Long userId);

    boolean existsByHabitIdAndCompletedDate(
            Long habitId,
            LocalDate completedDate);

    boolean existsByHabitIdAndUserIdAndCompletedDate(
            Long habitId,
            Long userId,
            LocalDate completedDate);

    void deleteByHabitIdAndUserId(Long habitId, Long userId);

}
