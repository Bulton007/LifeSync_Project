package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.Notifications;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface NotificationRepository extends JpaRepository<Notifications, Long> {

    List<Notifications> findAllByUserIdOrderByCreatedAtDesc(Long userId);

    List<Notifications> findByUserIdAndIsReadFalse(Long userId);

    Optional<Notifications> findByNotificationIdAndUserId(Long notificationId, Long userId);

}
