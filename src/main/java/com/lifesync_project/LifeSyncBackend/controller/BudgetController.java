package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.Budget.BudgetRequest;
import com.lifesync_project.LifeSyncBackend.dto.Budget.BudgetResponse;
import com.lifesync_project.LifeSyncBackend.services.BudgetService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/budgets")
@RequiredArgsConstructor
public class BudgetController {

    private final BudgetService budgetService;

    @PostMapping
    public ResponseEntity<BudgetResponse> create(
            @Valid @RequestBody BudgetRequest request) {

        return ResponseEntity.ok(
                budgetService.createBudget(request));
    }

    @GetMapping
    public ResponseEntity<List<BudgetResponse>> getAll() {

        return ResponseEntity.ok(
                budgetService.getBudgets());
    }

    @GetMapping("/{id}")
    public ResponseEntity<BudgetResponse> getById(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                budgetService.getBudgetById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<BudgetResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody BudgetRequest request) {

        return ResponseEntity.ok(
                budgetService.updateBudget(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable Long id) {

        budgetService.deleteBudget(id);

        return ResponseEntity.noContent().build();
    }
}