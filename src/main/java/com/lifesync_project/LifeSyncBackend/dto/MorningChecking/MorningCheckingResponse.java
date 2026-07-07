package com.lifesync_project.LifeSyncBackend.dto.MorningChecking;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MorningCheckingResponse {

    private Long id;

    private Long userId;

    private Integer moodRating;

    private String notes;

    private LocalDateTime checkedInAt;
}
