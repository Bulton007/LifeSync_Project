package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.FlashcardReview.FlashcardReviewRequest;
import com.lifesync_project.LifeSyncBackend.dto.FlashcardReview.FlashcardReviewResponse;
import com.lifesync_project.LifeSyncBackend.services.FlashcardReviewService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/flashcard-reviews")
@RequiredArgsConstructor
public class FlashcardReviewController {

    private final FlashcardReviewService reviewService;

    @PostMapping
    public ResponseEntity<FlashcardReviewResponse> create(
            @Valid @RequestBody FlashcardReviewRequest request) {

        return ResponseEntity.ok(
                reviewService.createReview(request));
    }

    @GetMapping
    public ResponseEntity<List<FlashcardReviewResponse>> getAll(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long cardId) {

        return ResponseEntity.ok(
                reviewService.getReviews(userId, cardId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<FlashcardReviewResponse> getById(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                reviewService.getReviewById(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable Long id) {

        reviewService.deleteReview(id);

        return ResponseEntity.noContent().build();
    }
}
