package com.lifesync_project.LifeSyncBackend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Users {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false,length =100)
    private String fullName;

    @Column(nullable = false,unique = true)
    private String email;

    @Column(unique = true,length =20)
    private String phoneNumber;

    @Column(nullable = false)
    private String password;

    @Builder.Default
    private Boolean verified = false;

    private String otpCode;

    private LocalDateTime otpExpiredAt;

    private String profileImage;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}