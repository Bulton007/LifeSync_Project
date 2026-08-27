package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Expense.ExpenseRequest;
import com.lifesync_project.LifeSyncBackend.dto.Expense.ExpenseResponse;
import com.lifesync_project.LifeSyncBackend.entity.Expense;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.ExpenseRepository;
import com.lifesync_project.LifeSyncBackend.repository.CategoryRepository;
import com.lifesync_project.LifeSyncBackend.exception.BadRequestException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ExpenseService {

    private final ExpenseRepository expenseRepository;
    private final CategoryRepository categoryRepository;
    private final AuthenticatedUserService authenticatedUserService;

    public ExpenseResponse createExpense(ExpenseRequest request) {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        requireCategory(request.getCategoryId());
        Expense expense = Expense.builder()
                .userId(userId)
                .categoryId(request.getCategoryId())
                .title(request.getTitle())
                .description(request.getDescription())
                .amount(request.getAmount())
                .expenseDate(request.getExpenseDate())
                .build();

        return mapToResponse(expenseRepository.save(expense));
    }

    public ExpenseResponse updateExpense(
            Long id,
            ExpenseRequest request) {

        Expense expense = requireOwned(id);
        requireCategory(request.getCategoryId());

        expense.setCategoryId(request.getCategoryId());
        expense.setTitle(request.getTitle());
        expense.setDescription(request.getDescription());
        expense.setAmount(request.getAmount());
        expense.setExpenseDate(request.getExpenseDate());

        return mapToResponse(expenseRepository.save(expense));
    }

    public void deleteExpense(Long id) {

        Expense expense = requireOwned(id);

        expenseRepository.delete(expense);
    }

    public ExpenseResponse getExpenseById(Long id) {

        return mapToResponse(requireOwned(id));
    }

    public List<ExpenseResponse> getExpenses() {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return expenseRepository.findAllByUserIdOrderByExpenseDateDesc(userId)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public List<ExpenseResponse> filterExpenseByDate(
            LocalDate startDate,
            LocalDate endDate) {

        if (endDate.isBefore(startDate)) {
            throw new BadRequestException("End date cannot be before start date.");
        }
        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return expenseRepository
                .findByUserIdAndExpenseDateBetweenOrderByExpenseDateDesc(userId, startDate, endDate)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    private ExpenseResponse mapToResponse(Expense expense) {

        return ExpenseResponse.builder()
                .id(expense.getId())
                .userId(expense.getUserId())
                .categoryId(expense.getCategoryId())
                .title(expense.getTitle())
                .description(expense.getDescription())
                .amount(expense.getAmount())
                .expenseDate(expense.getExpenseDate())
                .createdAt(expense.getCreatedAt())
                .updatedAt(expense.getUpdatedAt())
                .build();
    }

    private Expense requireOwned(Long id) {
        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return expenseRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Expense not found"));
    }

    private void requireCategory(Long id) {
        if (!categoryRepository.existsById(id)) {
            throw new ResourceNotFoundException("Category not found.");
        }
    }

}
