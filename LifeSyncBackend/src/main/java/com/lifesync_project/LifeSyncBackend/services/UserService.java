package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.User.UserRequest;
import com.lifesync_project.LifeSyncBackend.dto.User.UserResponse;
import com.lifesync_project.LifeSyncBackend.entity.User;
import com.lifesync_project.LifeSyncBackend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional

public class UserService {

    private final UserRepository userRepository;

    public User createUser(UserRequest request) {
        // 1. Business Logic: Check for duplicates
        if (userRepository.existsByName(request.getName())) {
            throw new IllegalArgumentException("Username is already taken.");
        }
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email is already registered.");
        }
        String image_urls = request.getProfile_image_url();
        if(image_urls == null || image_urls.isBlank()){
            image_urls = null;
        }
        // 2. Build the User entity using Lombok's Builder
        User newUser = User.builder()
                .name(request.getName())
                .email(request.getEmail())
                .password(request.getPassword())
                .phonenumber(request.getPhonenumber())
                .profile_image_url(image_urls)
                .build();

        // 3. Save to database (Safe from SQL Injection automatically)
        return userRepository.save(newUser);
    }

    public boolean loginUser(UserRequest request){


        return true;
    }

}
