package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.WeeklyReview.WeeklyReviewRequest;
import com.lifesync_project.LifeSyncBackend.dto.WeeklyReview.WeeklyReviewResponse;
import com.lifesync_project.LifeSyncBackend.services.WeeklyReviewService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/weekly-reviews")
@RequiredArgsConstructor
public class WeeklyReviewController {

    private final WeeklyReviewService reviewService;

    @PostMapping
    public ResponseEntity<WeeklyReviewResponse> create(
            @Valid @RequestBody WeeklyReviewRequest request) {

        return ResponseEntity.ok(
                reviewService.createReview(request));
    }

    @GetMapping
    public ResponseEntity<List<WeeklyReviewResponse>> getAll(
            @RequestParam(required = false) Long userId) {

        return ResponseEntity.ok(
                reviewService.getReviews(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<WeeklyReviewResponse> getById(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                reviewService.getReviewById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<WeeklyReviewResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody WeeklyReviewRequest request) {

        return ResponseEntity.ok(
                reviewService.updateReview(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable Long id) {

        reviewService.deleteReview(id);

        return ResponseEntity.noContent().build();
    }
}
