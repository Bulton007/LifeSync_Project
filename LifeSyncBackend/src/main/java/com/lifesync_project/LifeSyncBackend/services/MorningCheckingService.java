package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.MorningChecking.MorningCheckingRequest;
import com.lifesync_project.LifeSyncBackend.dto.MorningChecking.MorningCheckingResponse;
import com.lifesync_project.LifeSyncBackend.entity.MorningChecking;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.MorningCheckingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class MorningCheckingService {

    private final MorningCheckingRepository checkingRepository;

    public MorningCheckingResponse createChecking(MorningCheckingRequest request) {

        MorningChecking checking = MorningChecking.builder()
                .userId(request.getUserId())
                .moodRating(request.getMoodRating())
                .notes(request.getNotes())
                .checkedInAt(LocalDateTime.now())
                .build();

        return mapToResponse(
                checkingRepository.save(checking));
    }

    public List<MorningCheckingResponse> getCheckings(Long userId) {

        List<MorningChecking> checkings = userId == null
                ? checkingRepository.findAll()
                : checkingRepository.findByUserId(userId);

        return checkings.stream()
                .map(this::mapToResponse)
                .toList();
    }

    public MorningCheckingResponse getCheckingById(Long id) {

        return mapToResponse(findChecking(id));
    }

    public MorningCheckingResponse updateChecking(Long id, MorningCheckingRequest request) {

        MorningChecking checking = findChecking(id);

        checking.setUserId(request.getUserId());
        checking.setMoodRating(request.getMoodRating());
        checking.setNotes(request.getNotes());

        return mapToResponse(
                checkingRepository.save(checking));
    }

    public void deleteChecking(Long id) {

        checkingRepository.delete(findChecking(id));
    }

    private MorningChecking findChecking(Long id) {

        return checkingRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Morning checking not found"));
    }

    private MorningCheckingResponse mapToResponse(MorningChecking checking) {

        return MorningCheckingResponse.builder()
                .id(checking.getId())
                .userId(checking.getUserId())
                .moodRating(checking.getMoodRating())
                .notes(checking.getNotes())
                .checkedInAt(checking.getCheckedInAt())
                .build();
    }
}
