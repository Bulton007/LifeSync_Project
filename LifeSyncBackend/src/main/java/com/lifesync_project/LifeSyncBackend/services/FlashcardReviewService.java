package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.FlashcardReview.FlashcardReviewRequest;
import com.lifesync_project.LifeSyncBackend.dto.FlashcardReview.FlashcardReviewResponse;
import com.lifesync_project.LifeSyncBackend.entity.Flashcard;
import com.lifesync_project.LifeSyncBackend.entity.FlashcardReview;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.FlashcardRepository;
import com.lifesync_project.LifeSyncBackend.repository.FlashcardReviewRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class FlashcardReviewService {

    private final FlashcardReviewRepository reviewRepository;
    private final FlashcardRepository flashcardRepository;

    public FlashcardReviewResponse createReview(FlashcardReviewRequest request) {

        Flashcard card = flashcardRepository.findById(request.getCardId())
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Flashcard not found"));

        FlashcardReview review = FlashcardReview.builder()
                .card(card)
                .userId(request.getUserId())
                .known(request.getKnown())
                .reviewedAt(LocalDateTime.now())
                .build();

        return mapToResponse(
                reviewRepository.save(review));
    }

    public List<FlashcardReviewResponse> getReviews(Long userId, Long cardId) {

        List<FlashcardReview> reviews;

        if (userId != null) {
            reviews = reviewRepository.findByUserId(userId);
        } else if (cardId != null) {
            reviews = reviewRepository.findByCardId(cardId);
        } else {
            reviews = reviewRepository.findAll();
        }

        return reviews.stream()
                .map(this::mapToResponse)
                .toList();
    }

    public FlashcardReviewResponse getReviewById(Long id) {

        return mapToResponse(findReview(id));
    }

    public void deleteReview(Long id) {

        reviewRepository.delete(findReview(id));
    }

    private FlashcardReview findReview(Long id) {

        return reviewRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Flashcard review not found"));
    }

    private FlashcardReviewResponse mapToResponse(FlashcardReview review) {

        return FlashcardReviewResponse.builder()
                .id(review.getId())
                .cardId(review.getCard().getId())
                .userId(review.getUserId())
                .known(review.getKnown())
                .reviewedAt(review.getReviewedAt())
                .build();
    }
}
