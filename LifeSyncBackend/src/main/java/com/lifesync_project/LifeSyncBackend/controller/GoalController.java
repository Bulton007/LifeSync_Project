package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.Goal.GoalRequest;
import com.lifesync_project.LifeSyncBackend.dto.Goal.GoalResponse;
import com.lifesync_project.LifeSyncBackend.services.GoalService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/goals")
@RequiredArgsConstructor
public class GoalController {

    private final GoalService goalService;

    @PostMapping
    public GoalResponse createGoal(@Valid @RequestBody GoalRequest request) {
        return goalService.createGoal(request);
    }

    @PutMapping("/{id}")
    public GoalResponse updateGoal(
            @PathVariable Long id,
            @Valid @RequestBody GoalRequest request) {

        return goalService.updateGoal(id, request);
    }

    @DeleteMapping("/{id}")
    public void deleteGoal(@PathVariable Long id) {
        goalService.deleteGoal(id);
    }

    @GetMapping("/{id}")
    public GoalResponse getGoalById(@PathVariable Long id) {
        return goalService.getGoalById(id);
    }

    @GetMapping
    public List<GoalResponse> getGoals() {
        return goalService.getGoals();
    }

    @PatchMapping("/{id}/complete")
    public GoalResponse completeGoal(@PathVariable Long id) {
        return goalService.completeGoal(id);
    }

    @PatchMapping("/{id}/archive")
    public GoalResponse archiveGoal(@PathVariable Long id) {
        return goalService.archiveGoal(id);
    }

}