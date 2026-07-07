package com.lifesync_project.LifeSyncBackend.dto.Win;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WinResponse {

    private Long id;

    private String title;

    private String description;

    private LocalDateTime createdAt;
}