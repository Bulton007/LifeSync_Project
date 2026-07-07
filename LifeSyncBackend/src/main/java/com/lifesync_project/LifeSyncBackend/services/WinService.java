package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Win.WinRequest;
import com.lifesync_project.LifeSyncBackend.dto.Win.WinResponse;
import com.lifesync_project.LifeSyncBackend.entity.Win;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.WinRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional

public class WinService {

    private final WinRepository repository;

    public WinResponse createWin(
            WinRequest
                    request) {

        Win win = Win.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .createdAt(LocalDateTime.now())
                .build();

        return mapToResponse(
                repository.save(win));
    }

    public List<WinResponse> getWins() {

        return repository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public WinResponse getWinById(
            Long id) {

        Win win = findWin(id);

        return mapToResponse(win);
    }

    public WinResponse updateWin(Long id, WinRequest request) {

        Win win = findWin(id);

        win.setTitle(request.getTitle());
        win.setDescription(request.getDescription());

        return mapToResponse(
                repository.save(win));
    }

    public void deleteWin(Long id) {

        repository.delete(findWin(id));
    }

    private Win findWin(Long id) {

        return repository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Win not found"));
    }

    private WinResponse mapToResponse(Win win) {

        return WinResponse.builder()
                .id(win.getId())
                .title(win.getTitle())
                .description(win.getDescription())
                .createdAt(win.getCreatedAt())
                .build();
    }
}
