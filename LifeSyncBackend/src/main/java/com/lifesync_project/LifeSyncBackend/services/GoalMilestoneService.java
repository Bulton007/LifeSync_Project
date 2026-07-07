package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.GoalMilestone.GoalMilestoneRequest;
import com.lifesync_project.LifeSyncBackend.dto.GoalMilestone.GoalMilestoneResponse;
import com.lifesync_project.LifeSyncBackend.entity.GoalMilestone;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.GoalMilestoneRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class GoalMilestoneService {

    private final GoalMilestoneRepository repository;

    public GoalMilestoneResponse createMilestone(
            Long goalId,
            GoalMilestoneRequest request) {

        GoalMilestone milestone =
                GoalMilestone.builder()
                        .title(request.getTitle())
                        .completed(false)
                        .targetDate(request.getTargetDate())
                        .goalId(goalId)
                        .build();

        return mapToResponse(
                repository.save(milestone));
    }

    public GoalMilestoneResponse completeMilestone(
            Long id) {

        GoalMilestone milestone =
                repository.findById(id)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "Milestone not found"));

        milestone.setCompleted(true);

        return mapToResponse(
                repository.save(milestone));
    }
    public List<GoalMilestoneResponse> getMilestonesByGoal(
            Long goalId) {

        return repository
                .findByGoalId(goalId)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }
    public void deleteMilestone(Long id) {

        GoalMilestone milestone =
                repository.findById(id)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "Milestone not found"));

        repository.delete(milestone);
    }
    private GoalMilestoneResponse mapToResponse(
            GoalMilestone milestone) {

        return GoalMilestoneResponse.builder()
                .id(milestone.getId())
                .title(milestone.getTitle())
                .completed(milestone.getCompleted())
                .targetDate(milestone.getTargetDate())
                .goalId(milestone.getGoalId())
                .build();
    }
}
