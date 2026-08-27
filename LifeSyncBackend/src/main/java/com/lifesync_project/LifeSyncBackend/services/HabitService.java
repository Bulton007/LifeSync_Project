package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Habit.HabitRequest;
import com.lifesync_project.LifeSyncBackend.dto.Habit.HabitResponse;
import com.lifesync_project.LifeSyncBackend.entity.Habits;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.HabitRepository;
import com.lifesync_project.LifeSyncBackend.repository.HabitLogRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class HabitService {

    private final HabitRepository habitRepository;
    private final HabitLogRepository habitLogRepository;
    private final AuthenticatedUserService authenticatedUserService;

    /**
     * Create Habit
     */
    public HabitResponse createHabit(HabitRequest request) {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        validateDates(request);

        Habits habit = Habits.builder()
                .userId(userId)
                .name(request.getName())
                .description(request.getDescription())
                .frequency(request.getFrequency())
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .active(true)
                .streak(0)
                .build();

        return mapToResponse(habitRepository.save(habit));
    }

    /**
     * Update Habit
     */
    public HabitResponse updateHabit(Long id, HabitRequest request) {

        Habits habit = requireOwnedHabit(id);
        validateDates(request);

        habit.setName(request.getName());
        habit.setDescription(request.getDescription());
        habit.setFrequency(request.getFrequency());
        habit.setStartDate(request.getStartDate());
        habit.setEndDate(request.getEndDate());

        return mapToResponse(habitRepository.save(habit));
    }

    /**
     * Delete Habit
     */
    public void deleteHabit(Long id) {

        Habits habit = requireOwnedHabit(id);

        habitLogRepository.deleteByHabitIdAndUserId(id, habit.getUserId());
        habitRepository.delete(habit);
    }

    /**
     * Get Habit By Id
     */
    public HabitResponse getHabitById(Long id) {

        return mapToResponse(requireOwnedHabit(id));
    }

    /**
     * Get All Habits
     */
    public List<HabitResponse> getHabits() {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return habitRepository.findAllByUserIdOrderByCreatedAtDesc(userId)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    /**
     * Pause Habit
     */
    public HabitResponse pauseHabit(Long id) {

        Habits habit = requireOwnedHabit(id);

        habit.setActive(false);

        return mapToResponse(habitRepository.save(habit));
    }

    /**
     * Resume Habit
     */
    public HabitResponse resumeHabit(Long id) {

        Habits habit = requireOwnedHabit(id);

        habit.setActive(true);

        return mapToResponse(habitRepository.save(habit));
    }

    /**
     * Entity -> Response
     */
    private HabitResponse mapToResponse(Habits habit) {

        return HabitResponse.builder()
                .habitId(habit.getHabitId())
                .userId(habit.getUserId())
                .name(habit.getName())
                .description(habit.getDescription())
                .frequency(habit.getFrequency())
                .streak(habit.getStreak())
                .active(habit.getActive())
                .startDate(habit.getStartDate())
                .endDate(habit.getEndDate())
                .createdAt(habit.getCreatedAt())
                .updatedAt(habit.getUpdatedAt())
                .build();
    }

    private Habits requireOwnedHabit(Long id) {
        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return habitRepository.findByHabitIdAndUserId(id, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Habit not found"));
    }

    private void validateDates(HabitRequest request) {
        if (request.getStartDate() != null && request.getEndDate() != null
                && request.getEndDate().isBefore(request.getStartDate())) {
            throw new com.lifesync_project.LifeSyncBackend.exception.BadRequestException(
                    "Habit end date cannot be before its start date.");
        }
    }
}
