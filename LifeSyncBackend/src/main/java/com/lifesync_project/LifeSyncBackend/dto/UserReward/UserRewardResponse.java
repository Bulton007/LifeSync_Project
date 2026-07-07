package com.lifesync_project.LifeSyncBackend.dto.UserReward;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserRewardResponse {

    private Long id;

    private Long userId;

    private Integer points;

    private Integer level;

    private LocalDateTime updatedAt;
}
