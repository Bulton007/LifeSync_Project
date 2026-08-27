package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.MorningChecking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MorningCheckingRepository
        extends JpaRepository<MorningChecking, Long> {

    List<MorningChecking> findAllByUserIdOrderByCheckedInAtDesc(Long userId);

    Optional<MorningChecking> findByIdAndUserId(Long id, Long userId);
}
