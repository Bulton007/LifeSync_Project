package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.SubTask.SubTaskRequest;
import com.lifesync_project.LifeSyncBackend.dto.SubTask.SubTaskResponse;
import com.lifesync_project.LifeSyncBackend.entity.SubTasks;
import com.lifesync_project.LifeSyncBackend.entity.Tasks;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.SubTaskRepository;
import com.lifesync_project.LifeSyncBackend.repository.TaskRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class SubTaskService {

    private final SubTaskRepository subTaskRepository;
    private final TaskRepository taskRepository;

    public SubTaskResponse createSubTask(
            Long taskId,
            SubTaskRequest request) {

        Tasks task = taskRepository.findById(taskId)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Task not found"));

        SubTasks subTask = SubTasks.builder()
                .title(request.getTitle())
                .completed(false)
                .task(task)
                .build();

        return mapToResponse(
                subTaskRepository.save(subTask));
    }

    public List<SubTaskResponse> getByTask(Long taskId) {

        return subTaskRepository
                .findByTaskId(taskId)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public SubTaskResponse getSubTaskById(Long id) {

        return mapToResponse(findSubTask(id));
    }

    public SubTaskResponse updateSubTask(Long id, SubTaskRequest request) {

        SubTasks subTask = findSubTask(id);

        subTask.setTitle(request.getTitle());

        return mapToResponse(
                subTaskRepository.save(subTask));
    }

    public SubTaskResponse completeSubTask(Long id) {

        SubTasks subTask = findSubTask(id);

        subTask.setCompleted(true);

        return mapToResponse(
                subTaskRepository.save(subTask));
    }

    public void deleteSubTask(Long id) {

        subTaskRepository.delete(findSubTask(id));
    }

    private SubTasks findSubTask(Long id) {

        return subTaskRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "SubTask not found"));
    }

    private SubTaskResponse mapToResponse(SubTasks subTask) {

        return SubTaskResponse.builder()
                .id(subTask.getId())
                .title(subTask.getTitle())
                .completed(subTask.isCompleted())
                .taskId(subTask.getTask().getId())
                .build();
    }
}
