package com.lifesync_project.LifeSyncBackend.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.UUID;

/**
 * Filter that tracks incoming HTTP requests and responses.
 * Assigns a unique requestId (MDC and X-Request-ID header) and logs method, URI,
 * status code, execution duration, client IP, and user identity.
 */
@Slf4j
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class RequestLoggingFilter extends OncePerRequestFilter {

    public static final String REQUEST_ID_HEADER = "X-Request-ID";
    public static final String MDC_REQUEST_ID_KEY = "requestId";

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain)
            throws ServletException, IOException {

        // Extract existing correlation ID or generate a new unique one
        String requestId = request.getHeader(REQUEST_ID_HEADER);
        if (requestId == null || requestId.isBlank()) {
            requestId = UUID.randomUUID().toString().substring(0, 8);
        }

        // Put requestId in MDC so every log on this thread includes it
        MDC.put(MDC_REQUEST_ID_KEY, requestId);
        response.setHeader(REQUEST_ID_HEADER, requestId);

        long startTime = System.currentTimeMillis();
        String method = request.getMethod();
        String uri = request.getRequestURI();
        String queryString = request.getQueryString();
        String fullPath = (queryString != null) ? (uri + "?" + queryString) : uri;
        String clientIp = getClientIp(request);

        try {
            filterChain.doFilter(request, response);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            int status = response.getStatus();
            String user = getCurrentUser();

            String logMessage = String.format(
                    "HTTP %s %s -> %d (took %d ms) | User: %s | IP: %s",
                    method, fullPath, status, duration, user, clientIp
            );

            if (status >= 500) {
                log.error(logMessage);
            } else if (status >= 400) {
                log.warn(logMessage);
            } else {
                log.info(logMessage);
            }

            MDC.remove(MDC_REQUEST_ID_KEY);
        }
    }

    private String getClientIp(HttpServletRequest request) {
        String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader != null && !xfHeader.isBlank()) {
            return xfHeader.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

    private String getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            return auth.getName();
        }
        return "anonymous";
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        // Skip logging for static assets or swagger docs
        return path.startsWith("/swagger-ui")
                || path.startsWith("/v3/api-docs")
                || path.endsWith(".ico")
                || path.endsWith(".css")
                || path.endsWith(".js");
    }
}
