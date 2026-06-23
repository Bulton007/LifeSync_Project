package com.lifesync_project.LifeSyncBackend.dto.Task;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TaskResponse {

    private Long id;

    private String title;

    private String description;

    private String priority;

    private String status;

    private LocalDate dueDate;

    private LocalDateTime createdAt;
}