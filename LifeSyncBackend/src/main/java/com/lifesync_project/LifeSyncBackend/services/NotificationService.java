package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Notification.NotificationRequest;
import com.lifesync_project.LifeSyncBackend.dto.Notification.NotificationResponse;
import com.lifesync_project.LifeSyncBackend.entity.Notifications;
import com.lifesync_project.LifeSyncBackend.entity.Users;
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
    private final AuthenticatedUserService authenticatedUserService;

    public NotificationResponse createNotification(NotificationRequest request) {

        Users currentUser = authenticatedUserService.requireCurrentUser();

        Notifications notification = Notifications.builder()
                .userId(currentUser.getId())
                .title(request.getTitle())
                .message(request.getMessage())
                .type(request.getType())
                .build();

        return mapToResponse(notificationRepository.save(notification));
    }

    public NotificationResponse getNotificationById(Long id) {

        return mapToResponse(findOwnedNotification(id));
    }

    public List<NotificationResponse> getNotifications() {

        Users currentUser = authenticatedUserService.requireCurrentUser();

        return notificationRepository.findAllByUserIdOrderByCreatedAtDesc(currentUser.getId())
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public NotificationResponse markAsRead(Long id) {

        Notifications notification = findOwnedNotification(id);

        notification.setIsRead(true);

        return mapToResponse(notificationRepository.save(notification));
    }

    public void markAllAsRead() {

        Users currentUser = authenticatedUserService.requireCurrentUser();

        List<Notifications> notifications =
                notificationRepository.findByUserIdAndIsReadFalse(currentUser.getId());

        notifications.forEach(n -> n.setIsRead(true));

        notificationRepository.saveAll(notifications);
    }

    public void deleteNotification(Long id) {

        notificationRepository.delete(findOwnedNotification(id));
    }

    private Notifications findOwnedNotification(Long id) {
        Users currentUser = authenticatedUserService.requireCurrentUser();

        return notificationRepository.findByNotificationIdAndUserId(id, currentUser.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Notification not found"));
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
