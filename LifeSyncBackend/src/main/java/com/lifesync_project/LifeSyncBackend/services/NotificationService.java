package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Notification.NotificationRequest;
import com.lifesync_project.LifeSyncBackend.dto.Notification.NotificationResponse;
import com.lifesync_project.LifeSyncBackend.entity.Notifications;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.NotificationRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class NotificationService {

    private final NotificationRepository notificationRepository;

    public NotificationResponse createNotification(NotificationRequest request) {

        Notifications notification = Notifications.builder()
                .userId(request.getUserId())
                .title(request.getTitle())
                .message(request.getMessage())
                .type(request.getType())
                .build();

        return mapToResponse(notificationRepository.save(notification));
    }

    public NotificationResponse getNotificationById(Long id) {

        Notifications notification = notificationRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Notification not found"));

        return mapToResponse(notification);
    }

    public List<NotificationResponse> getNotifications() {

        return notificationRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public NotificationResponse markAsRead(Long id) {

        Notifications notification = notificationRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Notification not found"));

        notification.setIsRead(true);

        return mapToResponse(notificationRepository.save(notification));
    }

    public void markAllAsRead(Long userId) {

        List<Notifications> notifications =
                notificationRepository.findByUserIdAndIsReadFalse(userId);

        notifications.forEach(n -> n.setIsRead(true));

        notificationRepository.saveAll(notifications);
    }

    public void deleteNotification(Long id) {

        Notifications notification =
                notificationRepository.findById(id)
                        .orElseThrow(() ->
                                new ResourceNotFoundException("Notification not found"));

        notificationRepository.delete(notification);
    }

    private NotificationResponse mapToResponse(Notifications notification) {

        return NotificationResponse.builder()
                .notificationId(notification.getNotificationId())
                .userId(notification.getUserId())
                .title(notification.getTitle())
                .message(notification.getMessage())
                .type(notification.getType())
                .isRead(notification.getIsRead())
                .createdAt(notification.getCreatedAt())
                .build();
    }

}