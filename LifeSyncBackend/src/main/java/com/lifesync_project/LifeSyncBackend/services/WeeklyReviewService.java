package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.WeeklyReview.WeeklyReviewRequest;
import com.lifesync_project.LifeSyncBackend.dto.WeeklyReview.WeeklyReviewResponse;
import com.lifesync_project.LifeSyncBackend.entity.WeeklyReview;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.WeeklyReviewRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class WeeklyReviewService {

    private final WeeklyReviewRepository reviewRepository;

    public WeeklyReviewResponse createReview(WeeklyReviewRequest request) {

        WeeklyReview review = WeeklyReview.builder()
                .userId(request.getUserId())
                .reviewSummary(request.getReviewSummary())
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .createdAt(LocalDateTime.now())
                .build();

        return mapToResponse(
                reviewRepository.save(review));
    }

    public List<WeeklyReviewResponse> getReviews(Long userId) {

        List<WeeklyReview> reviews = userId == null
                ? reviewRepository.findAll()
                : reviewRepository.findByUserId(userId);

        return reviews.stream()
                .map(this::mapToResponse)
                .toList();
    }

    public WeeklyReviewResponse getReviewById(Long id) {

        return mapToResponse(findReview(id));
    }

    public WeeklyReviewResponse updateReview(Long id, WeeklyReviewRequest request) {

        WeeklyReview review = findReview(id);

        review.setUserId(request.getUserId());
        review.setReviewSummary(request.getReviewSummary());
        review.setStartDate(request.getStartDate());
        review.setEndDate(request.getEndDate());

        return mapToResponse(
                reviewRepository.save(review));
    }

    public void deleteReview(Long id) {

        reviewRepository.delete(findReview(id));
    }

    private WeeklyReview findReview(Long id) {

        return reviewRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Weekly review not found"));
    }

    private WeeklyReviewResponse mapToResponse(WeeklyReview review) {

        return WeeklyReviewResponse.builder()
                .id(review.getId())
                .userId(review.getUserId())
                .reviewSummary(review.getReviewSummary())
                .startDate(review.getStartDate())
                .endDate(review.getEndDate())
                .createdAt(review.getCreatedAt())
                .build();
    }
}
