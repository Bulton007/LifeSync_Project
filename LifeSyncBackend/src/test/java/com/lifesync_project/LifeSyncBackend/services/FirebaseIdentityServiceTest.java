package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.exception.UnauthorizedException;
import org.junit.jupiter.api.Test;
import org.springframework.security.oauth2.jwt.Jwt;
import java.time.Instant;
import java.util.Map;
import static org.junit.jupiter.api.Assertions.*;

class FirebaseIdentityServiceTest {
    private Jwt.Builder token() {
        return Jwt.withTokenValue("test-only")
                .header("alg", "RS256").subject("google-user")
                .issuedAt(Instant.now().minusSeconds(60))
                .expiresAt(Instant.now().plusSeconds(300))
                .claim("auth_time", Instant.now().minusSeconds(60).getEpochSecond())
                .claim("email", "Person@example.com").claim("email_verified", true)
                .claim("name", " Person ")
                .claim("firebase", Map.of("sign_in_provider", "google.com"));
    }

    @Test
    void acceptsVerifiedGoogleClaims() {
        var identity = FirebaseIdentityService.identity(token().build());
        assertEquals("person@example.com", identity.email());
        assertEquals("Person", identity.name());
    }

    @Test
    void rejectsUnverifiedEmail() {
        assertThrows(UnauthorizedException.class, () -> FirebaseIdentityService.identity(
                token().claim("email_verified", false).build()));
    }

    @Test
    void rejectsOtherProviders() {
        assertThrows(UnauthorizedException.class, () -> FirebaseIdentityService.identity(
                token().claim("firebase", Map.of("sign_in_provider", "password")).build()));
    }

    @Test
    void rejectsExpiredAndFutureAuthentication() {
        assertThrows(UnauthorizedException.class, () -> FirebaseIdentityService.identity(
                token().expiresAt(Instant.now().minusSeconds(10)).build()));
        assertThrows(UnauthorizedException.class, () -> FirebaseIdentityService.identity(
                token().claim("auth_time", Instant.now().plusSeconds(600).getEpochSecond()).build()));
    }

    @Test
    void rejectsUnconfiguredProject() {
        assertThrows(IllegalStateException.class, () -> new FirebaseIdentityService("").verify("test-only"));
    }
}
