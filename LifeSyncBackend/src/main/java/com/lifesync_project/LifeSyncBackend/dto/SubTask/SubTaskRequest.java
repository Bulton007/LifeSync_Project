package com.lifesync_project.LifeSyncBackend.dto.SubTask;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SubTaskRequest {

    @NotBlank
    @Size(max = 200)
    private String title;
}