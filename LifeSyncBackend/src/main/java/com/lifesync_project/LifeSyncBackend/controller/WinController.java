package com.lifesync_project.LifeSyncBackend.controller;


import com.lifesync_project.LifeSyncBackend.dto.Win.WinRequest;
import com.lifesync_project.LifeSyncBackend.dto.Win.WinResponse;
import com.lifesync_project.LifeSyncBackend.services.WinService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/wins")
@RequiredArgsConstructor
public class WinController {

    private final WinService winService;

    @PostMapping
    public ResponseEntity<WinResponse> createWin(
            @Valid @RequestBody WinRequest request) {

        return ResponseEntity.ok(
                winService.createWin(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<WinResponse> updateWin(
            @PathVariable Long id,
            @Valid @RequestBody WinRequest request) {

        return ResponseEntity.ok(
                winService.updateWin(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteWin(
            @PathVariable Long id) {

        winService.deleteWin(id);

        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<WinResponse> getWinById(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                winService.getWinById(id));
    }

    @GetMapping
    public ResponseEntity<List<WinResponse>> getWins() {

        return ResponseEntity.ok(
                winService.getWins());
    }
}