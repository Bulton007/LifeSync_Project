package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.Expense.ExpenseRequest;
import com.lifesync_project.LifeSyncBackend.dto.Expense.ExpenseResponse;
import com.lifesync_project.LifeSyncBackend.services.ExpenseService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/expenses")
@RequiredArgsConstructor
public class ExpenseController {

    private final ExpenseService expenseService;

    @PostMapping
    public ExpenseResponse createExpense(
            @Valid @RequestBody ExpenseRequest request) {

        return expenseService.createExpense(request);
    }

    @PutMapping("/{id}")
    public ExpenseResponse updateExpense(
            @PathVariable Long id,
            @Valid @RequestBody ExpenseRequest request) {

        return expenseService.updateExpense(id, request);
    }

    @DeleteMapping("/{id}")
    public void deleteExpense(
            @PathVariable Long id) {

        expenseService.deleteExpense(id);
    }

    @GetMapping("/{id}")
    public ExpenseResponse getExpenseById(
            @PathVariable Long id) {

        return expenseService.getExpenseById(id);
    }

    @GetMapping
    public List<ExpenseResponse> getExpenses() {

        return expenseService.getExpenses();
    }

    @GetMapping("/filter")
    public List<ExpenseResponse> filterExpenseByDate(

            @RequestParam LocalDate startDate,

            @RequestParam LocalDate endDate) {

        return expenseService.filterExpenseByDate(
                startDate,
                endDate);
    }

}