package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.User.UserRequest;
import com.lifesync_project.LifeSyncBackend.dto.User.UserResponse;
import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
@Transactional
public class UserService {

    private final UserRepository userRepository;

    /*
     * Get Profile
     */
    public UserResponse getProfile(Long id) {

        Users user = userRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found"));

        return mapToResponse(user);
    }

    /*
     * Update Profile
     */
    public UserResponse updateProfile(
            Long id,
            UserRequest request) {

        Users user = userRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found"));

        user.setFullName(request.getFullName());
        user.setEmail(request.getEmail());
        user.setPhoneNumber(request.getPhoneNumber());

        return mapToResponse(
                userRepository.save(user));
    }

    /*
     * Upload Profile Image
     */
    public String uploadProfileImage(
            Long id,
            MultipartFile file) {

        Users user = userRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found"));

        // TODO
        // Save image to storage

        user.setProfileImage(file.getOriginalFilename());

        userRepository.save(user);

        return "Profile image uploaded successfully.";
    }

    /*
     * Delete Profile Image
     */
    public String deleteProfileImage(Long id){

        Users user = userRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found"));

        user.setProfileImage(null);

        userRepository.save(user);

        return "Profile image deleted successfully.";
    }

    /*
     * Mapper
     */
    private UserResponse mapToResponse(
            Users user){

        return UserResponse.builder()
                .id(user.getId())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .phoneNumber(user.getPhoneNumber())
                .verified(user.getVerified())
                .profileImage(user.getProfileImage())
                .createdAt(user.getCreatedAt())
                .build();
    }

}