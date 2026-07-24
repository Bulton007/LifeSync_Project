package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.HabitLog.HabitLogRequest;
import com.lifesync_project.LifeSyncBackend.dto.HabitLog.HabitLogResponse;
import com.lifesync_project.LifeSyncBackend.entity.HabitLogs;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.HabitLogRepository;
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

    public HabitLogResponse createHabitLog(HabitLogRequest request) {

        HabitLogs log = HabitLogs.builder()
                .habitId(request.getHabitId())
                .userId(request.getUserId())
                .completedDate(request.getCompletedDate())
                .note(request.getNote())
                .completed(true)
                .build();

        return mapToResponse(habitLogRepository.save(log));
    }

    public HabitLogResponse completeHabitToday(Long habitId, Long userId) {

        if (habitLogRepository.existsByHabitIdAndCompletedDate(
                habitId,
                LocalDate.now())) {

            throw new RuntimeException("Habit already completed today.");
        }

        HabitLogs log = HabitLogs.builder()
                .habitId(habitId)
                .userId(userId)
                .completedDate(LocalDate.now())
                .completed(true)
                .build();

        return mapToResponse(habitLogRepository.save(log));
    }

    public HabitLogResponse getHabitLogById(Long id) {

        HabitLogs log = habitLogRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Habit Log not found"));

        return mapToResponse(log);
    }

    public List<HabitLogResponse> getHabitLogs() {

        return habitLogRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public List<HabitLogResponse> getHabitLogsByHabit(Long habitId) {

        return habitLogRepository.findByHabitId(habitId)
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
}