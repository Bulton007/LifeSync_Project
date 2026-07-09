package com.lifesync_project.LifeSyncBackend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String email;

    private String phonenumber;

    private String password;

    private String profile_image_url;

    private String languages;

    private String theme;

    private Boolean is_verified;

    private LocalDateTime created_at;

    private LocalDateTime updated_at;
}
