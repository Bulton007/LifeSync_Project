package com.lifesync_project.LifeSyncBackend.controller;


import com.lifesync_project.LifeSyncBackend.dto.SubTask.SubTaskRequest;
import com.lifesync_project.LifeSyncBackend.dto.SubTask.SubTaskResponse;
import com.lifesync_project.LifeSyncBackend.services.SubTaskService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/subtasks")
@RequiredArgsConstructor
public class SubTaskController {

    private final SubTaskService subTaskService;

    @PostMapping("/{taskId}")
    public ResponseEntity<SubTaskResponse> createSubTask(
            @PathVariable Long taskId,
            @Valid @RequestBody SubTaskRequest request) {

        return ResponseEntity.ok(
                subTaskService.createSubTask(taskId, request));
    }

    @GetMapping("/task/{taskId}")
    public ResponseEntity<List<SubTaskResponse>> getByTask(
            @PathVariable Long taskId) {

        return ResponseEntity.ok(
                subTaskService.getByTask(taskId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<SubTaskResponse> getById(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                subTaskService.getSubTaskById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<SubTaskResponse> updateSubTask(
            @PathVariable Long id,
            @Valid @RequestBody SubTaskRequest request) {

        return ResponseEntity.ok(
                subTaskService.updateSubTask(id, request));
    }

    @PatchMapping("/{id}/complete")
    public ResponseEntity<SubTaskResponse> completeSubTask(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                subTaskService.completeSubTask(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSubTask(
            @PathVariable Long id) {

        subTaskService.deleteSubTask(id);

        return ResponseEntity.noContent().build();
    }
}