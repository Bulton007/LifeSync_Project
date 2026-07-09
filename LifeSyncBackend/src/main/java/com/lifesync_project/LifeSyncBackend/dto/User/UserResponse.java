package com.lifesync_project.LifeSyncBackend.dto.User;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {
    private Long id;

    private String name;

    private String email;

    private String phonenumber;

    private String password;

    private String profile_image_url;

    private String languages;

    private String theme;

    private Boolean is_verified;
}
