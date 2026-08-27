package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.HabitLog.HabitLogRequest;
import com.lifesync_project.LifeSyncBackend.dto.HabitLog.HabitLogResponse;
import com.lifesync_project.LifeSyncBackend.entity.HabitLogs;
import com.lifesync_project.LifeSyncBackend.entity.Habits;
import com.lifesync_project.LifeSyncBackend.exception.DuplicateResourceException;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.HabitLogRepository;
import com.lifesync_project.LifeSyncBackend.repository.HabitRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class HabitLogService {

    private final HabitLogRepository habitLogRepository;
    private final HabitRepository habitRepository;
    private final AuthenticatedUserService authenticatedUserService;

    public HabitLogResponse createHabitLog(HabitLogRequest request) {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        Habits habit = requireOwnedHabit(request.getHabitId(), userId);
        if (habitLogRepository.existsByHabitIdAndUserIdAndCompletedDate(
                habit.getHabitId(), userId, request.getCompletedDate())) {
            throw new DuplicateResourceException("Habit is already completed for that date.");
        }

        HabitLogs log = HabitLogs.builder()
                .habitId(request.getHabitId())
                .userId(userId)
                .completedDate(request.getCompletedDate())
                .note(request.getNote())
                .completed(true)
                .build();

        HabitLogResponse response = mapToResponse(habitLogRepository.save(log));
        updateStreak(habit, userId);
        return response;
    }

    public HabitLogResponse completeHabitToday(Long habitId) {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        Habits habit = requireOwnedHabit(habitId, userId);

        if (habitLogRepository.existsByHabitIdAndUserIdAndCompletedDate(
                habitId,
                userId,
                LocalDate.now())) {

            throw new DuplicateResourceException("Habit is already completed today.");
        }

        HabitLogs log = HabitLogs.builder()
                .habitId(habitId)
                .userId(userId)
                .completedDate(LocalDate.now())
                .completed(true)
                .build();

        HabitLogResponse response = mapToResponse(habitLogRepository.save(log));
        updateStreak(habit, userId);
        return response;
    }

    public HabitLogResponse getHabitLogById(Long id) {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        HabitLogs log = habitLogRepository.findByHabitLogIdAndUserId(id, userId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Habit Log not found"));

        return mapToResponse(log);
    }

    public List<HabitLogResponse> getHabitLogs() {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return habitLogRepository.findAllByUserIdOrderByCompletedDateDesc(userId)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public List<HabitLogResponse> getHabitLogsByHabit(Long habitId) {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        requireOwnedHabit(habitId, userId);
        return habitLogRepository.findAllByHabitIdAndUserIdOrderByCompletedDateDesc(habitId, userId)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    private HabitLogResponse mapToResponse(HabitLogs log) {

        return HabitLogResponse.builder()
                .habitLogId(log.getHabitLogId())
                .habitId(log.getHabitId())
                .userId(log.getUserId())
                .completedDate(log.getCompletedDate())
                .completed(log.getCompleted())
                .note(log.getNote())
                .createdAt(log.getCreatedAt())
                .updatedAt(log.getUpdatedAt())
                .build();
    }

    private Habits requireOwnedHabit(Long habitId, Long userId) {
        return habitRepository.findByHabitIdAndUserId(habitId, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Habit not found"));
    }

    private void updateStreak(Habits habit, Long userId) {
        var completedDates = habitLogRepository
                .findAllByHabitIdAndUserIdOrderByCompletedDateDesc(habit.getHabitId(), userId)
                .stream()
                .filter(log -> Boolean.TRUE.equals(log.getCompleted()))
                .map(HabitLogs::getCompletedDate)
                .distinct()
                .toList();

        int streak = 0;
        LocalDate expected = LocalDate.now();
        for (LocalDate date : completedDates) {
            if (date.equals(expected)) {
                streak++;
                expected = expected.minusDays(1);
            } else if (date.isBefore(expected)) {
                break;
            }
        }

        habit.setStreak(streak);
        habitRepository.save(habit);
    }
}
