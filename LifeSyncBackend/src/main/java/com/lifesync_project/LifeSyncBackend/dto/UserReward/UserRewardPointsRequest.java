package com.lifesync_project.LifeSyncBackend.dto.UserReward;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRewardPointsRequest {

    @NotNull
    @Positive(message = "Points must be greater than zero")
    private Integer points;
}
