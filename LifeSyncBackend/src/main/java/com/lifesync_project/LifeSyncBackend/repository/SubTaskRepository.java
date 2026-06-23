package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.SubTasks;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;

@Repository
public interface SubTaskRepository
        extends JpaRepository<SubTasks, Long> {

    List<SubTasks> findByTaskId(Long taskId);

}