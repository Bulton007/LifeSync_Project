package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.GoalSchedule.GoalScheduleRequest;
import com.lifesync_project.LifeSyncBackend.dto.GoalSchedule.GoalScheduleResponse;
import com.lifesync_project.LifeSyncBackend.services.GoalScheduleService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/goal-schedules")
@RequiredArgsConstructor
public class GoalScheduleController {
    private final GoalScheduleService service;

    @PostMapping
    public GoalScheduleResponse create(@Valid @RequestBody GoalScheduleRequest request) {
        return service.create(request);
    }

    @GetMapping("/goal/{goalId}")
    public List<GoalScheduleResponse> getByGoal(@PathVariable Long goalId) {
        return service.getByGoal(goalId);
    }

    @PutMapping("/{id}")
    public GoalScheduleResponse update(@PathVariable Long id, @Valid @RequestBody GoalScheduleRequest request) {
        return service.update(id, request);
    }

    @PatchMapping("/{id}/complete")
    public GoalScheduleResponse complete(@PathVariable Long id) {
        return service.complete(id);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
