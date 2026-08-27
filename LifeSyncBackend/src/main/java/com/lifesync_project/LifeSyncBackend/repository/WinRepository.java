package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.Win;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface WinRepository extends JpaRepository<Win, Long> {

    List<Win> findAllByUserIdOrderByCreatedAtDesc(Long userId);

    Optional<Win> findByIdAndUserId(Long id, Long userId);
}
