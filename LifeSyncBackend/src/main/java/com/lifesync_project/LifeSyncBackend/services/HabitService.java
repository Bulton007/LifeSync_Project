package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Habit.HabitRequest;
import com.lifesync_project.LifeSyncBackend.dto.Habit.HabitResponse;
import com.lifesync_project.LifeSyncBackend.entity.Habits;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.HabitRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class HabitService {

    private final HabitRepository habitRepository;

    /**
     * Create Habit
     */
    public HabitResponse createHabit(HabitRequest request) {

        Habits habit = Habits.builder()
                .userId(request.getUserId())
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

        Habits habit = habitRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Habit not found"));

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

        Habits habit = habitRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Habit not found"));

        habitRepository.delete(habit);
    }

    /**
     * Get Habit By Id
     */
    public HabitResponse getHabitById(Long id) {

        Habits habit = habitRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Habit not found"));

        return mapToResponse(habit);
    }

    /**
     * Get All Habits
     */
    public List<HabitResponse> getHabits() {

        return habitRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    /**
     * Pause Habit
     */
    public HabitResponse pauseHabit(Long id) {

        Habits habit = habitRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Habit not found"));

        habit.setActive(false);

        return mapToResponse(habitRepository.save(habit));
    }

    /**
     * Resume Habit
     */
    public HabitResponse resumeHabit(Long id) {

        Habits habit = habitRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Habit not found"));

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
}