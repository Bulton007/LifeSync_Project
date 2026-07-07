package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Flashcard.FlashcardRequest;
import com.lifesync_project.LifeSyncBackend.dto.Flashcard.FlashcardResponse;
import com.lifesync_project.LifeSyncBackend.entity.Flashcard;
import com.lifesync_project.LifeSyncBackend.entity.FlashcardDeck;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.FlashcardDeckRepository;
import com.lifesync_project.LifeSyncBackend.repository.FlashcardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class FlashcardService {

    private final FlashcardRepository flashcardRepository;
    private final FlashcardDeckRepository deckRepository;

    public FlashcardResponse createFlashcard(FlashcardRequest request) {

        FlashcardDeck deck = findDeck(request.getDeckId());

        Flashcard flashcard = Flashcard.builder()
                .deck(deck)
                .frontText(request.getFrontText())
                .backText(request.getBackText())
                .createdAt(LocalDateTime.now())
                .build();

        return mapToResponse(
                flashcardRepository.save(flashcard));
    }

    public List<FlashcardResponse> getFlashcards(Long deckId) {

        List<Flashcard> flashcards = deckId == null
                ? flashcardRepository.findAll()
                : flashcardRepository.findByDeckId(deckId);

        return flashcards.stream()
                .map(this::mapToResponse)
                .toList();
    }

    public FlashcardResponse getFlashcardById(Long id) {

        return mapToResponse(findFlashcard(id));
    }

    public FlashcardResponse updateFlashcard(Long id, FlashcardRequest request) {

        Flashcard flashcard = findFlashcard(id);
        FlashcardDeck deck = findDeck(request.getDeckId());

        flashcard.setDeck(deck);
        flashcard.setFrontText(request.getFrontText());
        flashcard.setBackText(request.getBackText());

        return mapToResponse(
                flashcardRepository.save(flashcard));
    }

    public void deleteFlashcard(Long id) {

        flashcardRepository.delete(findFlashcard(id));
    }

    private FlashcardDeck findDeck(Long id) {

        return deckRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Flashcard deck not found"));
    }

    private Flashcard findFlashcard(Long id) {

        return flashcardRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Flashcard not found"));
    }

    private FlashcardResponse mapToResponse(Flashcard flashcard) {

        return FlashcardResponse.builder()
                .id(flashcard.getId())
                .deckId(flashcard.getDeck().getId())
                .frontText(flashcard.getFrontText())
                .backText(flashcard.getBackText())
                .createdAt(flashcard.getCreatedAt())
                .build();
    }
}
