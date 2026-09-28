package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.services.FirebaseIdentityService;
import com.lifesync_project.LifeSyncBackend.services.AuthService;
import com.lifesync_project.LifeSyncBackend.dto.Auth.LoginResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class GoogleAuthController {
    private final FirebaseIdentityService identities;
    private final AuthService auth;
    public record GoogleRequest(@NotBlank @Size(max = 16384) String idToken) {}

    @PostMapping("/google")
    public LoginResponse login(@Valid @RequestBody GoogleRequest request) {
        return auth.googleLogin(identities.verify(request.idToken()));
    }
}
