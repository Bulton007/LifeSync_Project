package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.UserReward.UserRewardRequest;
import com.lifesync_project.LifeSyncBackend.dto.UserReward.UserRewardResponse;
import com.lifesync_project.LifeSyncBackend.entity.UserReward;
import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.exception.DuplicateResourceException;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.UserRewardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class UserRewardService {

    private final UserRewardRepository rewardRepository;
    private final AuthenticatedUserService authenticatedUserService;

    public UserRewardResponse createReward(UserRewardRequest request) {

        Users currentUser = authenticatedUserService.requireCurrentUser();

        if (rewardRepository.existsByUserId(currentUser.getId())) {
            throw new DuplicateResourceException("Reward already exists for this user");
        }

        int points = request.getPoints() == null ? 0 : request.getPoints();

        UserReward reward = UserReward.builder()
                .userId(currentUser.getId())
                .points(points)
                .level(calculateLevel(points))
                .updatedAt(LocalDateTime.now())
                .build();

        return mapToResponse(
                rewardRepository.save(reward));
    }

    public List<UserRewardResponse> getRewards() {

        Users currentUser = authenticatedUserService.requireCurrentUser();

        return rewardRepository.findByUserId(currentUser.getId()).stream()
                .map(this::mapToResponse)
                .toList();
    }

    public UserRewardResponse getRewardById(Long id) {

        return mapToResponse(findReward(id));
    }

    public UserRewardResponse getRewardByUserId(Long userId) {

        authenticatedUserService.requireOwner(userId);

        UserReward reward = rewardRepository.findByUserId(userId)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "User reward not found"));

        return mapToResponse(reward);
    }

    public UserRewardResponse updateReward(Long id, UserRewardRequest request) {

        UserReward reward = findReward(id);

        reward.setPoints(request.getPoints() == null ? reward.getPoints() : request.getPoints());
        reward.setLevel(calculateLevel(reward.getPoints()));
        reward.setUpdatedAt(LocalDateTime.now());

        return mapToResponse(
                rewardRepository.save(reward));
    }

    public UserRewardResponse addPoints(Long userId, Integer points) {

        authenticatedUserService.requireOwner(userId);

        UserReward reward = rewardRepository.findByUserId(userId)
                .orElseGet(() -> UserReward.builder()
                        .userId(userId)
                        .points(0)
                        .level(1)
                        .build());

        reward.setPoints(reward.getPoints() + points);
        reward.setLevel(calculateLevel(reward.getPoints()));
        reward.setUpdatedAt(LocalDateTime.now());

        return mapToResponse(
                rewardRepository.save(reward));
    }

    public UserRewardResponse subtractPoints(Long userId, Integer points) {

        authenticatedUserService.requireOwner(userId);

        UserReward reward = rewardRepository.findByUserId(userId)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "User reward not found"));

        reward.setPoints(Math.max(0, reward.getPoints() - points));
        reward.setLevel(calculateLevel(reward.getPoints()));
        reward.setUpdatedAt(LocalDateTime.now());

        return mapToResponse(
                rewardRepository.save(reward));
    }

    public void deleteReward(Long id) {

        rewardRepository.delete(findReward(id));
    }

    private UserReward findReward(Long id) {

        Users currentUser = authenticatedUserService.requireCurrentUser();

        return rewardRepository.findByIdAndUserId(id, currentUser.getId())
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "User reward not found"));
    }

    private Integer calculateLevel(Integer points) {

        return (points / 100) + 1;
    }

    private UserRewardResponse mapToResponse(UserReward reward) {

        return UserRewardResponse.builder()
                .id(reward.getId())
                .userId(reward.getUserId())
                .points(reward.getPoints())
                .level(reward.getLevel())
                .updatedAt(reward.getUpdatedAt())
                .build();
    }
}
