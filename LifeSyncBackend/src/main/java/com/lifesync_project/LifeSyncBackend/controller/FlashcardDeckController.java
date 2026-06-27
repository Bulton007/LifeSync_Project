package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.FlashcardDeck.FlashcardDeckRequest;
import com.lifesync_project.LifeSyncBackend.dto.FlashcardDeck.FlashcardDeckResponse;
import com.lifesync_project.LifeSyncBackend.services.FlashcardDeckService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/flashcard-decks")
@RequiredArgsConstructor
public class FlashcardDeckController {

    private final FlashcardDeckService deckService;

    @PostMapping
    public ResponseEntity<FlashcardDeckResponse> create(
            @Valid @RequestBody FlashcardDeckRequest request) {

        return ResponseEntity.ok(
                deckService.createDeck(request));
    }

    @GetMapping
    public ResponseEntity<List<FlashcardDeckResponse>> getAll(
            @RequestParam(required = false) Long userId) {

        return ResponseEntity.ok(
                deckService.getDecks(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<FlashcardDeckResponse> getById(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                deckService.getDeckById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<FlashcardDeckResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody FlashcardDeckRequest request) {

        return ResponseEntity.ok(
                deckService.updateDeck(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable Long id) {

        deckService.deleteDeck(id);

        return ResponseEntity.noContent().build();
    }
}
