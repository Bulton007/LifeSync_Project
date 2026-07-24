package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.Habits;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface HabitRepository extends JpaRepository<Habits, Long> {

    List<Habits> findByUserId(Long userId);

    List<Habits> findByActive(Boolean active);

}