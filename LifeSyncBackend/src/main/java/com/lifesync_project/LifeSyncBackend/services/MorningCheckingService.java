package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.MorningChecking.MorningCheckingRequest;
import com.lifesync_project.LifeSyncBackend.dto.MorningChecking.MorningCheckingResponse;
import com.lifesync_project.LifeSyncBackend.entity.MorningChecking;
import com.lifesync_project.LifeSyncBackend.entity.Users;
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
    private final AuthenticatedUserService authenticatedUserService;

    public MorningCheckingResponse createChecking(MorningCheckingRequest request) {

        Users currentUser = authenticatedUserService.requireCurrentUser();

        MorningChecking checking = MorningChecking.builder()
                .userId(currentUser.getId())
                .moodRating(request.getMoodRating())
                .notes(request.getNotes())
                .checkedInAt(LocalDateTime.now())
                .build();

        return mapToResponse(
                checkingRepository.save(checking));
    }

    public List<MorningCheckingResponse> getCheckings() {

        Users currentUser = authenticatedUserService.requireCurrentUser();

        return checkingRepository.findAllByUserIdOrderByCheckedInAtDesc(currentUser.getId()).stream()
                .map(this::mapToResponse)
                .toList();
    }

    public MorningCheckingResponse getCheckingById(Long id) {

        return mapToResponse(findChecking(id));
    }

    public MorningCheckingResponse updateChecking(Long id, MorningCheckingRequest request) {

        MorningChecking checking = findChecking(id);

        checking.setMoodRating(request.getMoodRating());
        checking.setNotes(request.getNotes());

        return mapToResponse(
                checkingRepository.save(checking));
    }

    public void deleteChecking(Long id) {

        checkingRepository.delete(findChecking(id));
    }

    private MorningChecking findChecking(Long id) {

        Users currentUser = authenticatedUserService.requireCurrentUser();

        return checkingRepository.findByIdAndUserId(id, currentUser.getId())
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
