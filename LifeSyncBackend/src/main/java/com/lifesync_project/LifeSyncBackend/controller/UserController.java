package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.Users.UserRequest;
import com.lifesync_project.LifeSyncBackend.dto.Users.UserResponse;
import com.lifesync_project.LifeSyncBackend.services.UserService;
import com.lifesync_project.LifeSyncBackend.services.ProfileImageStorageService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import org.springframework.core.io.Resource;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final ProfileImageStorageService profileImageStorageService;

    /*
     * Get Profile
     */
    @GetMapping("/{id}")
    public ResponseEntity<UserResponse> getProfile(
            @PathVariable Long id){

        return ResponseEntity.ok(
                userService.getProfile(id));
    }

    /*
     * Update Profile
     */
    @PutMapping("/{id}")
    public ResponseEntity<UserResponse> updateProfile(
            @PathVariable Long id,
            @Valid @RequestBody UserRequest request){

        return ResponseEntity.ok(
                userService.updateProfile(id, request));
    }

    /*
     * Upload Profile Image
     */
    @PostMapping("/{id}/profile-image")
    public ResponseEntity<String> uploadProfileImage(
            @PathVariable Long id,
            @RequestParam("file") MultipartFile file){

        return ResponseEntity.ok(
                userService.uploadProfileImage(id, file));
    }

    /*
     * Delete Profile Image
     */
    @DeleteMapping("/{id}/profile-image")
    public ResponseEntity<String> deleteProfileImage(
            @PathVariable Long id){

        return ResponseEntity.ok(
                userService.deleteProfileImage(id));
    }

    @GetMapping("/{id}/profile-image")
    public ResponseEntity<Resource> getProfileImage(
            @PathVariable Long id) {

        UserResponse profile = userService.getProfile(id);
        Resource image = profileImageStorageService.load(profile.getProfileImage());

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(
                        profileImageStorageService.contentType(profile.getProfileImage())))
                .body(image);
    }

}
