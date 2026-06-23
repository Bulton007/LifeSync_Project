package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Win.WinRequest;
import com.lifesync_project.LifeSyncBackend.dto.Win.WinResponse;
import com.lifesync_project.LifeSyncBackend.entity.Win;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.WinRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

        Win win = repository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Win not found"));

        return mapToResponse(win);
    }
    private WinResponse mapToResponse(Win win) {

        return WinResponse.builder()
                .id(win.getId())
                .title(win.getTitle())
                .description(win.getDescription())
                .build();
    }
}