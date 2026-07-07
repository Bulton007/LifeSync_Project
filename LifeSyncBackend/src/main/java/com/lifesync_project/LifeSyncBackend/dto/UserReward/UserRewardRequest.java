package com.lifesync_project.LifeSyncBackend.dto.UserReward;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRewardRequest {

    @NotNull
    private Long userId;

    @Min(0)
    private Integer points;

    @Min(1)
    private Integer level;
}
