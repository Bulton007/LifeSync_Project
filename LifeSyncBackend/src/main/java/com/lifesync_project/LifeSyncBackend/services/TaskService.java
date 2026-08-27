package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Task.TaskRequest;
import com.lifesync_project.LifeSyncBackend.dto.Task.TaskResponse;
import com.lifesync_project.LifeSyncBackend.entity.Tasks;
import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.TaskRepository;
import com.lifesync_project.LifeSyncBackend.repository.SubTaskRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class TaskService {

    private final TaskRepository taskRepository;
    private final SubTaskRepository subTaskRepository;
    private final AuthenticatedUserService authenticatedUserService;

    public TaskResponse createTask(TaskRequest request) {

        Users currentUser = authenticatedUserService.requireCurrentUser();

        Tasks task = Tasks.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .priority(request.getPriority())
                .status(request.getStatus() == null ? "PENDING" : request.getStatus())
                .dueDate(request.getDueDate())
                .createdAt(LocalDateTime.now())
                .user(currentUser)
                .build();

        return mapToResponse(
                taskRepository.save(task));
    }

    public List<TaskResponse> getTasks() {

        Users currentUser = authenticatedUserService.requireCurrentUser();

        return taskRepository.findByUserIdOrderByDueDateAscCreatedAtAsc(currentUser.getId())
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public TaskResponse getTaskById(Long id) {

        Tasks task = findOwnedTask(id);

        return mapToResponse(task);
    }

    public TaskResponse updateTask(
            Long id,
            TaskRequest request) {

        Tasks task = findOwnedTask(id);

        task.setTitle(request.getTitle());
        task.setDescription(request.getDescription());
        task.setPriority(request.getPriority());
        task.setDueDate(request.getDueDate());
        if (request.getStatus() != null) {
            task.setStatus(request.getStatus());
        }

        return mapToResponse(
                taskRepository.save(task));
    }

    public void deleteTask(Long id) {

        Tasks task = findOwnedTask(id);

        subTaskRepository.deleteByTaskId(task.getId());
        taskRepository.delete(task);
    }

    public TaskResponse completeTask(Long id) {

        Tasks task = findOwnedTask(id);

        task.setStatus("COMPLETED");

        return mapToResponse(
                taskRepository.save(task));
    }

    private TaskResponse mapToResponse(
            Tasks task) {

        return TaskResponse.builder()
                .id(task.getId())
                .title(task.getTitle())
                .description(task.getDescription())
                .priority(task.getPriority())
                .status(task.getStatus())
                .dueDate(task.getDueDate())
                .createdAt(task.getCreatedAt())
                .build();
    }

    private Tasks findOwnedTask(Long id) {
        Users currentUser = authenticatedUserService.requireCurrentUser();

        return taskRepository.findByIdAndUserId(id, currentUser.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Task not found"));
    }
}
