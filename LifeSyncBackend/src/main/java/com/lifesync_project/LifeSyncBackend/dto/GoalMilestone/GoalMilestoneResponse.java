package com.lifesync_project.LifeSyncBackend.dto.GoalMilestone;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GoalMilestoneResponse {

    private Long id;

    private String title;

    private Boolean completed;

    private LocalDate targetDate;

    private Long goalId;
}