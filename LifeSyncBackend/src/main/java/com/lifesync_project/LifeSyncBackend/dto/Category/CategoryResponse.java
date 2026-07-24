package com.lifesync_project.LifeSyncBackend.dto.Category;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class CategoryResponse {

    private Long id;

    private String name;

    private String description;

    private String icon;

    private String color;

    private Boolean active;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

}