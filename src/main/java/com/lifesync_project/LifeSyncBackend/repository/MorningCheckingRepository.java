package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.MorningChecking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MorningCheckingRepository
        extends JpaRepository<MorningChecking, Long> {

    List<MorningChecking> findByUserId(Long userId);
}
