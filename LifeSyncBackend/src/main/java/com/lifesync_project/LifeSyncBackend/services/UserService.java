package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Users.UserRequest;
import com.lifesync_project.LifeSyncBackend.dto.Users.UserResponse;
import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.exception.BadRequestException;
import com.lifesync_project.LifeSyncBackend.exception.DuplicateResourceException;
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
    private final AuthenticatedUserService authenticatedUserService;
    private final ProfileImageStorageService profileImageStorageService;

    /*
     * Get Profile
     */
    public UserResponse getProfile(Long id) {

        Users user = authenticatedUserService.requireOwner(id);

        return mapToResponse(user);
    }

    /*
     * Update Profile
     */
    public UserResponse updateProfile(
            Long id,
            UserRequest request) {

        Users user = authenticatedUserService.requireOwner(id);

        if (!user.getEmail().equalsIgnoreCase(request.getEmail())
                && userRepository.existsByEmail(request.getEmail())) {
            throw new DuplicateResourceException("Email already exists.");
        }

        if (request.getPhoneNumber() != null
                && !request.getPhoneNumber().equals(user.getPhoneNumber())
                && userRepository.existsByPhoneNumber(request.getPhoneNumber())) {
            throw new DuplicateResourceException("Phone number already exists.");
        }

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

        Users user = authenticatedUserService.requireOwner(id);

        if (file == null || file.isEmpty()) {
            throw new BadRequestException("Profile image file is required.");
        }

        if (file.getSize() > 5L * 1024L * 1024L) {
            throw new BadRequestException("Profile image must not exceed 5 MB.");
        }

        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new BadRequestException("Profile image must be an image file.");
        }

        String previousImage = user.getProfileImage();
        String storedFileName = profileImageStorageService.store(file);

        user.setProfileImage(storedFileName);

        userRepository.save(user);

        profileImageStorageService.delete(previousImage);

        return "Profile image uploaded successfully.";
    }

    /*
     * Delete Profile Image
     */
    public String deleteProfileImage(Long id){

        Users user = authenticatedUserService.requireOwner(id);

        String previousImage = user.getProfileImage();
        user.setProfileImage(null);

        userRepository.save(user);

        profileImageStorageService.delete(previousImage);

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
