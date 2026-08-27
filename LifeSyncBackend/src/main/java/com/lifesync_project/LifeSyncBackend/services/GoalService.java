package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Goal.GoalRequest;
import com.lifesync_project.LifeSyncBackend.dto.Goal.GoalResponse;
import com.lifesync_project.LifeSyncBackend.entity.Goals;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.GoalRepository;
import com.lifesync_project.LifeSyncBackend.repository.GoalMilestoneRepository;
import com.lifesync_project.LifeSyncBackend.repository.GoalScheduleRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
@Transactional
public class GoalService {

    private final GoalRepository goalRepository;
    private final GoalMilestoneRepository goalMilestoneRepository;
    private final GoalScheduleRepository goalScheduleRepository;
    private final AuthenticatedUserService authenticatedUserService;

    public GoalResponse createGoal(GoalRequest request) {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        Goals goal = Goals.builder()
                .userId(userId)
                .title(request.getTitle())
                .description(request.getDescription())
                .targetAmount(request.getTargetAmount())
                .currentAmount(request.getCurrentAmount() == null ? BigDecimal.ZERO : request.getCurrentAmount())
                .deadline(request.getDeadline())
                .completed(false)
                .archived(false)
                .build();

        return mapToResponse(goalRepository.save(goal));
    }

    public GoalResponse updateGoal(Long id, GoalRequest request) {

        Goals goal = requireOwnedGoal(id);

        goal.setTitle(request.getTitle());
        goal.setDescription(request.getDescription());
        goal.setTargetAmount(request.getTargetAmount());
        goal.setCurrentAmount(request.getCurrentAmount() == null ? goal.getCurrentAmount() : request.getCurrentAmount());
        goal.setDeadline(request.getDeadline());

        return mapToResponse(goalRepository.save(goal));
    }

    public void deleteGoal(Long id) {

        Goals goal = requireOwnedGoal(id);

        goalMilestoneRepository.deleteByGoalId(id);
        goalScheduleRepository.deleteByGoalId(id);
        goalRepository.delete(goal);
    }

    public GoalResponse getGoalById(Long id) {

        return mapToResponse(requireOwnedGoal(id));
    }

    public List<GoalResponse> getGoals() {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return goalRepository.findAllByUserIdOrderByCreatedAtDesc(userId)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public GoalResponse completeGoal(Long id) {

        Goals goal = requireOwnedGoal(id);

        goal.setCompleted(true);

        return mapToResponse(goalRepository.save(goal));
    }

    public GoalResponse archiveGoal(Long id) {

        Goals goal = requireOwnedGoal(id);

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

    public Goals requireOwnedGoal(Long id) {
        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return goalRepository.findByGoalIdAndUserId(id, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Goal not found"));
    }

}
