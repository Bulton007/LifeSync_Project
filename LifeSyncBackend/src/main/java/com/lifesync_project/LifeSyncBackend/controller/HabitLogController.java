package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.HabitLog.HabitLogRequest;
import com.lifesync_project.LifeSyncBackend.dto.HabitLog.HabitLogResponse;
import com.lifesync_project.LifeSyncBackend.services.HabitLogService;
import lombok.RequiredArgsConstructor;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/habit-logs")
@RequiredArgsConstructor
public class HabitLogController {

    private final HabitLogService habitLogService;

    @PostMapping
    public HabitLogResponse createHabitLog(
            @Valid @RequestBody HabitLogRequest request) {

        return habitLogService.createHabitLog(request);
    }

    @PostMapping("/complete")
    public HabitLogResponse completeHabitToday(
            @RequestParam Long habitId,
            @RequestParam(required = false) Long userId) {

        return habitLogService.completeHabitToday(habitId);
    }

    @GetMapping("/{id}")
    public HabitLogResponse getHabitLogById(
            @PathVariable Long id) {

        return habitLogService.getHabitLogById(id);
    }

    @GetMapping
    public List<HabitLogResponse> getHabitLogs() {

        return habitLogService.getHabitLogs();
    }

    @GetMapping("/habit/{habitId}")
    public List<HabitLogResponse> getHabitLogsByHabit(
            @PathVariable Long habitId) {

        return habitLogService.getHabitLogsByHabit(habitId);
    }
}
