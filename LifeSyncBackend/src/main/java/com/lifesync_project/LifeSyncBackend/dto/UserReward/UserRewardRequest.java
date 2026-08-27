package com.lifesync_project.LifeSyncBackend.dto.UserReward;

import jakarta.validation.constraints.Min;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRewardRequest {

    private Long userId;

    @Min(0)
    private Integer points;

    @Min(1)
    private Integer level;
}
