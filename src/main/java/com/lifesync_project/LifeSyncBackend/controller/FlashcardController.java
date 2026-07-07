package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.Flashcard.FlashcardRequest;
import com.lifesync_project.LifeSyncBackend.dto.Flashcard.FlashcardResponse;
import com.lifesync_project.LifeSyncBackend.services.FlashcardService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/flashcards")
@RequiredArgsConstructor
public class FlashcardController {

    private final FlashcardService flashcardService;

    @PostMapping
    public ResponseEntity<FlashcardResponse> create(
            @Valid @RequestBody FlashcardRequest request) {

        return ResponseEntity.ok(
                flashcardService.createFlashcard(request));
    }

    @GetMapping
    public ResponseEntity<List<FlashcardResponse>> getAll(
            @RequestParam(required = false) Long deckId) {

        return ResponseEntity.ok(
                flashcardService.getFlashcards(deckId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<FlashcardResponse> getById(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                flashcardService.getFlashcardById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<FlashcardResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody FlashcardRequest request) {

        return ResponseEntity.ok(
                flashcardService.updateFlashcard(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable Long id) {

        flashcardService.deleteFlashcard(id);

        return ResponseEntity.noContent().build();
    }
}
