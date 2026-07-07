package com.lifesync_project.LifeSyncBackend.dto.GoalMilestone;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;


import java.time.LocalDate;

@Getter
@Setter
public class GoalMilestoneRequest {

    @NotBlank
    private String title;

    @NotNull
    private LocalDate targetDate;
}