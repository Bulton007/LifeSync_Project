package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.UserReward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRewardRepository
        extends JpaRepository<UserReward, Long> {

    Optional<UserReward> findByUserId(Long userId);

    boolean existsByUserId(Long userId);
}
