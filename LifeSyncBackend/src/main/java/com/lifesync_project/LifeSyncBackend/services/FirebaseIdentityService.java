package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.exception.UnauthorizedException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.core.DelegatingOAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2TokenValidatorResult;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.stereotype.Service;
import java.util.Map;
import java.time.Instant;

@Service
public class FirebaseIdentityService {
    private final JwtDecoder decoder;
    private final String project;

    public FirebaseIdentityService(@Value("${FIREBASE_PROJECT_ID:}") String project) {
        this.project = project.trim();
        var verifier = NimbusJwtDecoder.withJwkSetUri(
                "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com").build();
        verifier.setJwtValidator(new DelegatingOAuth2TokenValidator<>(
                JwtValidators.createDefaultWithIssuer("https://securetoken.google.com/" + this.project),
                token -> token.getAudience().contains(this.project)
                        ? OAuth2TokenValidatorResult.success()
                        : OAuth2TokenValidatorResult.failure(new OAuth2Error("invalid_token"))));
        decoder = verifier;
    }

    public record Identity(String email, String name) {}

    public Identity verify(String token) {
        if (project.isBlank()) throw new IllegalStateException("Google sign-in is not configured on the server.");
        try {
            return identity(decoder.decode(token));
        } catch (JwtException | IllegalArgumentException exception) {
            throw new UnauthorizedException("Google sign-in could not be verified. Please try again.");
        }
    }

    public static Identity identity(Jwt token) {
        String email = token.getClaimAsString("email");
        Map<String, Object> firebase = token.getClaim("firebase");
        Instant now = Instant.now();
        Instant authenticatedAt = token.getClaimAsInstant("auth_time");
        if (token.getSubject() == null || token.getSubject().isBlank()
                || token.getSubject().length() > 128
                || token.getExpiresAt() == null || token.getIssuedAt() == null
                || !token.getExpiresAt().isAfter(now) || token.getIssuedAt().isAfter(now)
                || authenticatedAt == null || authenticatedAt.isAfter(now)
                || email == null || email.isBlank() || email.length() > 254
                || !Boolean.TRUE.equals(token.getClaimAsBoolean("email_verified"))
                || firebase == null || !"google.com".equals(firebase.get("sign_in_provider"))) {
            throw new UnauthorizedException("A verified Google account is required.");
        }
        String name = token.getClaimAsString("name");
        return new Identity(email.trim().toLowerCase(java.util.Locale.ROOT),
                name == null ? "" : name.trim());
    }
}
