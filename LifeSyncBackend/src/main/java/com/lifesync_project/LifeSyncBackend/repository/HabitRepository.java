package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.Habits;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface HabitRepository extends JpaRepository<Habits, Long> {

    List<Habits> findByUserId(Long userId);

    List<Habits> findAllByUserIdOrderByCreatedAtDesc(Long userId);

    Optional<Habits> findByHabitIdAndUserId(Long habitId, Long userId);

    List<Habits> findByActive(Boolean active);

}
