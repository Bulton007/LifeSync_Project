package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.Habit.HabitRequest;
import com.lifesync_project.LifeSyncBackend.dto.Habit.HabitResponse;
import com.lifesync_project.LifeSyncBackend.services.HabitService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/habits")
@RequiredArgsConstructor
public class HabitController {

    private final HabitService habitService;

    @PostMapping
    public HabitResponse createHabit(
            @Valid @RequestBody HabitRequest request) {

        return habitService.createHabit(request);
    }

    @PutMapping("/{id}")
    public HabitResponse updateHabit(
            @PathVariable Long id,
            @Valid @RequestBody HabitRequest request) {

        return habitService.updateHabit(id, request);
    }

    @DeleteMapping("/{id}")
    public void deleteHabit(
            @PathVariable Long id) {

        habitService.deleteHabit(id);
    }

    @GetMapping("/{id}")
    public HabitResponse getHabitById(
            @PathVariable Long id) {

        return habitService.getHabitById(id);
    }

    @GetMapping
    public List<HabitResponse> getHabits() {

        return habitService.getHabits();
    }

    @PatchMapping("/{id}/pause")
    public HabitResponse pauseHabit(
            @PathVariable Long id) {

        return habitService.pauseHabit(id);
    }

    @PatchMapping("/{id}/resume")
    public HabitResponse resumeHabit(
            @PathVariable Long id) {

        return habitService.resumeHabit(id);
    }
}