package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.GoalSchedule.GoalScheduleRequest;
import com.lifesync_project.LifeSyncBackend.dto.GoalSchedule.GoalScheduleResponse;
import com.lifesync_project.LifeSyncBackend.entity.GoalSchedules;
import com.lifesync_project.LifeSyncBackend.entity.Goals;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.GoalRepository;
import com.lifesync_project.LifeSyncBackend.repository.GoalScheduleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class GoalScheduleService {
    private final GoalScheduleRepository repository;
    private final GoalRepository goalRepository;
    private final GoalService goalService;

    public GoalScheduleResponse create(GoalScheduleRequest request) {
        goalService.requireOwnedGoal(request.getGoalId());
        GoalSchedules schedule = GoalSchedules.builder()
                .goalId(request.getGoalId())
                .scheduleDate(request.getScheduleDate())
                .amount(request.getAmount())
                .completed(false)
                .build();
        return map(repository.save(schedule));
    }

    public List<GoalScheduleResponse> getByGoal(Long goalId) {
        goalService.requireOwnedGoal(goalId);
        return repository.findAllByGoalIdOrderByScheduleDateAsc(goalId).stream().map(this::map).toList();
    }

    public GoalScheduleResponse update(Long id, GoalScheduleRequest request) {
        GoalSchedules schedule = requireOwned(id);
        if (!schedule.getGoalId().equals(request.getGoalId())) {
            throw new ResourceNotFoundException("Goal schedule not found");
        }
        schedule.setScheduleDate(request.getScheduleDate());
        schedule.setAmount(request.getAmount());
        return map(repository.save(schedule));
    }

    public GoalScheduleResponse complete(Long id) {
        GoalSchedules schedule = requireOwned(id);
        if (!Boolean.TRUE.equals(schedule.getCompleted())) {
            Goals goal = goalService.requireOwnedGoal(schedule.getGoalId());
            goal.setCurrentAmount(goal.getCurrentAmount().add(schedule.getAmount()));
            goalRepository.save(goal);
            schedule.setCompleted(true);
        }
        return map(repository.save(schedule));
    }

    public void delete(Long id) {
        GoalSchedules schedule = requireOwned(id);
        repository.delete(schedule);
    }

    private GoalSchedules requireOwned(Long id) {
        GoalSchedules schedule = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Goal schedule not found"));
        goalService.requireOwnedGoal(schedule.getGoalId());
        return schedule;
    }

    private GoalScheduleResponse map(GoalSchedules schedule) {
        return GoalScheduleResponse.builder()
                .goalScheduleId(schedule.getGoalScheduleId())
                .goalId(schedule.getGoalId())
                .scheduleDate(schedule.getScheduleDate())
                .amount(schedule.getAmount())
                .completed(schedule.getCompleted())
                .createdAt(schedule.getCreatedAt())
                .updatedAt(schedule.getUpdatedAt())
                .build();
    }
}
