package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.Tasks;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TaskRepository
        extends JpaRepository<Tasks, Long> {

    List<Tasks> findByUserIdOrderByDueDateAscCreatedAtAsc(Long userId);

    Optional<Tasks> findByIdAndUserId(Long id, Long userId);
}
