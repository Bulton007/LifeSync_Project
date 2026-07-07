package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.MorningChecking.MorningCheckingRequest;
import com.lifesync_project.LifeSyncBackend.dto.MorningChecking.MorningCheckingResponse;
import com.lifesync_project.LifeSyncBackend.services.MorningCheckingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/morning-checkings")
@RequiredArgsConstructor
public class MorningCheckingController {

    private final MorningCheckingService checkingService;

    @PostMapping
    public ResponseEntity<MorningCheckingResponse> create(
            @Valid @RequestBody MorningCheckingRequest request) {

        return ResponseEntity.ok(
                checkingService.createChecking(request));
    }

    @GetMapping
    public ResponseEntity<List<MorningCheckingResponse>> getAll(
            @RequestParam(required = false) Long userId) {

        return ResponseEntity.ok(
                checkingService.getCheckings(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<MorningCheckingResponse> getById(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                checkingService.getCheckingById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<MorningCheckingResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody MorningCheckingRequest request) {

        return ResponseEntity.ok(
                checkingService.updateChecking(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable Long id) {

        checkingService.deleteChecking(id);

        return ResponseEntity.noContent().build();
    }
}
