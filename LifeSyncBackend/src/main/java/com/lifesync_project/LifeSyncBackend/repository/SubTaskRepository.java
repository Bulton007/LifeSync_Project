package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.SubTasks;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SubTaskRepository
        extends JpaRepository<SubTasks, Long> {

    List<SubTasks> findByTaskIdAndTaskUserId(Long taskId, Long userId);

    Optional<SubTasks> findByIdAndTaskUserId(Long id, Long userId);

    void deleteByTaskId(Long taskId);

}
