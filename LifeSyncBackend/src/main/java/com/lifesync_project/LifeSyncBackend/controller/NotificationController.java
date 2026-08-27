package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.Notification.NotificationRequest;
import com.lifesync_project.LifeSyncBackend.dto.Notification.NotificationResponse;
import com.lifesync_project.LifeSyncBackend.services.NotificationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @PostMapping
    public NotificationResponse createNotification(
            @Valid @RequestBody NotificationRequest request) {

        return notificationService.createNotification(request);
    }

    @GetMapping("/{id}")
    public NotificationResponse getNotificationById(
            @PathVariable Long id) {

        return notificationService.getNotificationById(id);
    }

    @GetMapping
    public List<NotificationResponse> getNotifications() {

        return notificationService.getNotifications();
    }

    @PatchMapping("/{id}/read")
    public NotificationResponse markAsRead(
            @PathVariable Long id) {

        return notificationService.markAsRead(id);
    }

    @PatchMapping("/read-all")
    public ResponseEntity<Void> markAllAsRead() {

        notificationService.markAllAsRead();

        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteNotification(
            @PathVariable Long id) {

        notificationService.deleteNotification(id);

        return ResponseEntity.noContent().build();
    }

}
