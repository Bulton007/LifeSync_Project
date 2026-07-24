package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Goal.GoalRequest;
import com.lifesync_project.LifeSyncBackend.dto.Goal.GoalResponse;
import com.lifesync_project.LifeSyncBackend.entity.Goals;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.GoalRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class GoalService {

    private final GoalRepository goalRepository;

    public GoalResponse createGoal(GoalRequest request) {

        Goals goal = Goals.builder()
                .userId(request.getUserId())
                .title(request.getTitle())
                .description(request.getDescription())
                .targetAmount(request.getTargetAmount())
                .currentAmount(request.getCurrentAmount())
                .deadline(request.getDeadline())
                .completed(false)
                .archived(false)
                .build();

        return mapToResponse(goalRepository.save(goal));
    }

    public GoalResponse updateGoal(Long id, GoalRequest request) {

        Goals goal = goalRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Goal not found"));

        goal.setTitle(request.getTitle());
        goal.setDescription(request.getDescription());
        goal.setTargetAmount(request.getTargetAmount());
        goal.setCurrentAmount(request.getCurrentAmount());
        goal.setDeadline(request.getDeadline());

        return mapToResponse(goalRepository.save(goal));
    }

    public void deleteGoal(Long id) {

        Goals goal = goalRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Goal not found"));

        goalRepository.delete(goal);
    }

    public GoalResponse getGoalById(Long id) {

        Goals goal = goalRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Goal not found"));

        return mapToResponse(goal);
    }

    public List<GoalResponse> getGoals() {

        return goalRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public GoalResponse completeGoal(Long id) {

        Goals goal = goalRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Goal not found"));

        goal.setCompleted(true);

        return mapToResponse(goalRepository.save(goal));
    }

    public GoalResponse archiveGoal(Long id) {

        Goals goal = goalRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Goal not found"));

        goal.setArchived(true);

        return mapToResponse(goalRepository.save(goal));
    }

    private GoalResponse mapToResponse(Goals goal) {

        return GoalResponse.builder()
                .id(goal.getGoalId())
                .userId(goal.getUserId())
                .title(goal.getTitle())
                .description(goal.getDescription())
                .targetAmount(goal.getTargetAmount())
                .currentAmount(goal.getCurrentAmount())
                .completed(goal.getCompleted())
                .archived(goal.getArchived())
                .deadline(goal.getDeadline())
                .createdAt(goal.getCreatedAt())
                .updatedAt(goal.getUpdatedAt())
                .build();
    }

}