package com.lifesync_project.LifeSyncBackend.dto.SubTask;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor

public class SubTaskResponse {

    private Long id;

    private String title;

    private Boolean completed;

    private Long taskId;
}