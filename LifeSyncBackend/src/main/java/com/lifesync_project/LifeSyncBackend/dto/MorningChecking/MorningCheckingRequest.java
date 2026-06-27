package com.lifesync_project.LifeSyncBackend.dto.MorningChecking;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MorningCheckingRequest {

    @NotNull
    private Long userId;

    @NotNull
    @Min(1)
    @Max(10)
    private Integer moodRating;

    @Size(max = 2000)
    private String notes;
}
