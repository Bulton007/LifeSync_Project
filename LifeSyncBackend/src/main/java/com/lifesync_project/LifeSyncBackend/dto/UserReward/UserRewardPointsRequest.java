package com.lifesync_project.LifeSyncBackend.dto.UserReward;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRewardPointsRequest {

    @NotNull
    private Integer points;
}
