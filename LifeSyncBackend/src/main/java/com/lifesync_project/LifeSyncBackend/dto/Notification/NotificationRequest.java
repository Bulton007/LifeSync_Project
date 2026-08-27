package com.lifesync_project.LifeSyncBackend.dto.Notification;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class NotificationRequest {

    private Long userId;

    @NotBlank(message = "Title is required")
    @Size(max = 200)
    private String title;

    @NotBlank(message = "Message is required")
    @Size(max = 2000)
    private String message;

    @Size(max = 80)
    private String type;

}
