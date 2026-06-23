package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Task.TaskRequest;
import com.lifesync_project.LifeSyncBackend.dto.Task.TaskResponse;
import com.lifesync_project.LifeSyncBackend.entity.Tasks;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.TaskRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class TaskService {

    private final TaskRepository taskRepository;
    private final UserRepository userRepository;

    public TaskResponse createTask(TaskRequest request) {

        User user = userRepository.findById(
                        request.getUserId())
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "User not found"));

        Tasks task = Tasks.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .priority(request.getPriority())
                .status(TaskStatus.PENDING)
                .dueDate(request.getDueDate())
                .user(user)
                .build();

        return mapToResponse(
                taskRepository.save(task));
    }

    public List<TaskResponse> getTasks() {

        return taskRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public TaskResponse getTaskById(Long id) {

        Tasks task = taskRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Task not found"));

        return mapToResponse(task);
    }

    public TaskResponse updateTask(
            Long id,
            TaskRequest request) {

        Tasks task = taskRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Task not found"));

        task.setTitle(request.getTitle());
        task.setDescription(request.getDescription());
        task.setPriority(request.getPriority());
        task.setDueDate(request.getDueDate());

        return mapToResponse(
                taskRepository.save(task));
    }

    public void deleteTask(Long id) {

        Tasks task = taskRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Task not found"));

        taskRepository.delete(task);
    }

    public TaskResponse completeTask(Long id) {

        Tasks task = taskRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Task not found"));

        task.setStatus(TaskStatus.COMPLETED);

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
                .build();
    }
}