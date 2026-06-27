package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.FlashcardDeck.FlashcardDeckRequest;
import com.lifesync_project.LifeSyncBackend.dto.FlashcardDeck.FlashcardDeckResponse;
import com.lifesync_project.LifeSyncBackend.entity.FlashcardDeck;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.FlashcardDeckRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class FlashcardDeckService {

    private final FlashcardDeckRepository deckRepository;

    public FlashcardDeckResponse createDeck(FlashcardDeckRequest request) {

        FlashcardDeck deck = FlashcardDeck.builder()
                .userId(request.getUserId())
                .title(request.getTitle())
                .description(request.getDescription())
                .createdAt(LocalDateTime.now())
                .build();

        return mapToResponse(
                deckRepository.save(deck));
    }

    public List<FlashcardDeckResponse> getDecks(Long userId) {

        List<FlashcardDeck> decks = userId == null
                ? deckRepository.findAll()
                : deckRepository.findByUserId(userId);

        return decks.stream()
                .map(this::mapToResponse)
                .toList();
    }

    public FlashcardDeckResponse getDeckById(Long id) {

        return mapToResponse(findDeck(id));
    }

    public FlashcardDeckResponse updateDeck(Long id, FlashcardDeckRequest request) {

        FlashcardDeck deck = findDeck(id);

        deck.setUserId(request.getUserId());
        deck.setTitle(request.getTitle());
        deck.setDescription(request.getDescription());

        return mapToResponse(
                deckRepository.save(deck));
    }

    public void deleteDeck(Long id) {

        deckRepository.delete(findDeck(id));
    }

    private FlashcardDeck findDeck(Long id) {

        return deckRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Flashcard deck not found"));
    }

    private FlashcardDeckResponse mapToResponse(FlashcardDeck deck) {

        return FlashcardDeckResponse.builder()
                .id(deck.getId())
                .userId(deck.getUserId())
                .title(deck.getTitle())
                .description(deck.getDescription())
                .createdAt(deck.getCreatedAt())
                .build();
    }
}
