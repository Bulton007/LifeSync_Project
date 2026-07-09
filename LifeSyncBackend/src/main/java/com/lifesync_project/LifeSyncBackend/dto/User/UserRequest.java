package com.lifesync_project.LifeSyncBackend.dto.User;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.UniqueElements;

@Getter
@Setter
public class UserRequest {
    @NotBlank
    @Size(max = 150)
    private String name;

    @NotNull
    private String email;

    @NotNull
    private String phonenumber;

    @NotNull
    private String password;

    @NotNull
    private String profile_image_url;

    @NotNull
    private String languages;

    @NotNull
    private String theme;
}
