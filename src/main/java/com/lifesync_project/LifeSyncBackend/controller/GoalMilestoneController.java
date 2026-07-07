package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.GoalMilestone.GoalMilestoneRequest;
import com.lifesync_project.LifeSyncBackend.dto.GoalMilestone.GoalMilestoneResponse;
import com.lifesync_project.LifeSyncBackend.services.GoalMilestoneService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/goal-milestones")
@RequiredArgsConstructor
public class GoalMilestoneController {

    private final GoalMilestoneService goalMilestoneService;

    @PostMapping("/{goalId}")
    public ResponseEntity<GoalMilestoneResponse> create(
            @PathVariable Long goalId,
            @Valid @RequestBody GoalMilestoneRequest request) {

        return ResponseEntity.ok(
                goalMilestoneService.createMilestone(
                        goalId,
                        request));
    }

    @GetMapping("/goal/{goalId}")
    public ResponseEntity<List<GoalMilestoneResponse>> getByGoal(
            @PathVariable Long goalId) {

        return ResponseEntity.ok(
                goalMilestoneService.getMilestonesByGoal(
                        goalId));
    }

    @PatchMapping("/{id}/complete")
    public ResponseEntity<GoalMilestoneResponse> complete(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                goalMilestoneService.completeMilestone(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable Long id) {

        goalMilestoneService.deleteMilestone(id);

        return ResponseEntity.noContent().build();
    }
}