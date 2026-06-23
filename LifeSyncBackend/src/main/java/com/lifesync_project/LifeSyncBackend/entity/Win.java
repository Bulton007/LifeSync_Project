package com.lifesync_project.LifeSyncBackend.entity;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "wins")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Win {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    private String description;

    private LocalDateTime createdAt;
}