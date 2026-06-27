package com.lifesync_project.LifeSyncBackend.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.Map;

@RestController
public class HealthController {

    @GetMapping("/")
    public Map<String, Object> home() {

        return Map.of(
                "application", "LifeSyncBackend",
                "status", "running",
                "healthUrl", "/api/health",
                "timestamp", LocalDateTime.now());
    }

    @GetMapping("/api/health")
    public Map<String, Object> health() {

        return Map.of(
                "status", "UP",
                "timestamp", LocalDateTime.now());
    }
}
