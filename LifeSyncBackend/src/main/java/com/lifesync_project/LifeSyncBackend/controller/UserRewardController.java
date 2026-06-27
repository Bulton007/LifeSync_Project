package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.UserReward.UserRewardPointsRequest;
import com.lifesync_project.LifeSyncBackend.dto.UserReward.UserRewardRequest;
import com.lifesync_project.LifeSyncBackend.dto.UserReward.UserRewardResponse;
import com.lifesync_project.LifeSyncBackend.services.UserRewardService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user-rewards")
@RequiredArgsConstructor
public class UserRewardController {

    private final UserRewardService rewardService;

    @PostMapping
    public ResponseEntity<UserRewardResponse> create(
            @Valid @RequestBody UserRewardRequest request) {

        return ResponseEntity.ok(
                rewardService.createReward(request));
    }

    @GetMapping
    public ResponseEntity<List<UserRewardResponse>> getAll() {

        return ResponseEntity.ok(
                rewardService.getRewards());
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserRewardResponse> getById(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                rewardService.getRewardById(id));
    }

    @GetMapping("/users/{userId}")
    public ResponseEntity<UserRewardResponse> getByUserId(
            @PathVariable Long userId) {

        return ResponseEntity.ok(
                rewardService.getRewardByUserId(userId));
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserRewardResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody UserRewardRequest request) {

        return ResponseEntity.ok(
                rewardService.updateReward(id, request));
    }

    @PatchMapping("/users/{userId}/add-points")
    public ResponseEntity<UserRewardResponse> addPoints(
            @PathVariable Long userId,
            @Valid @RequestBody UserRewardPointsRequest request) {

        return ResponseEntity.ok(
                rewardService.addPoints(userId, request.getPoints()));
    }

    @PatchMapping("/users/{userId}/subtract-points")
    public ResponseEntity<UserRewardResponse> subtractPoints(
            @PathVariable Long userId,
            @Valid @RequestBody UserRewardPointsRequest request) {

        return ResponseEntity.ok(
                rewardService.subtractPoints(userId, request.getPoints()));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable Long id) {

        rewardService.deleteReward(id);

        return ResponseEntity.noContent().build();
    }
}
