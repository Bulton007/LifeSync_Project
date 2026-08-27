package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.exception.ForbiddenException;
import com.lifesync_project.LifeSyncBackend.exception.UnauthorizedException;
import com.lifesync_project.LifeSyncBackend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthenticatedUserService {

    private final UserRepository userRepository;

    public Users requireCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || "anonymousUser".equals(authentication.getPrincipal())) {
            throw new UnauthorizedException("Authentication is required.");
        }

        return userRepository.findByEmail(authentication.getName())
                .orElseThrow(() -> new UnauthorizedException("Authenticated user no longer exists."));
    }

    public Users requireOwner(Long requestedUserId) {
        Users currentUser = requireCurrentUser();

        if (!currentUser.getId().equals(requestedUserId)) {
            throw new ForbiddenException("You cannot access another user's data.");
        }

        return currentUser;
    }
}
