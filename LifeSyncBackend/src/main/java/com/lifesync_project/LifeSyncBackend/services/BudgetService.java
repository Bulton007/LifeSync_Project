package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Budget.BudgetRequest;
import com.lifesync_project.LifeSyncBackend.dto.Budget.BudgetResponse;
import com.lifesync_project.LifeSyncBackend.entity.Budgets;
import com.lifesync_project.LifeSyncBackend.entity.Categories;
import com.lifesync_project.LifeSyncBackend.entity.Expense;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.BudgetRepository;
import com.lifesync_project.LifeSyncBackend.repository.CategoryRepository;
import com.lifesync_project.LifeSyncBackend.repository.ExpenseRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class BudgetService {
    private final BudgetRepository repository;
    private final CategoryRepository categoryRepository;
    private final ExpenseRepository expenseRepository;
    private final AuthenticatedUserService authenticatedUserService;

    public BudgetResponse createBudget(BudgetRequest request) {
        Long userId = authenticatedUserService.requireCurrentUser().getId();
        Categories category = requireCategory(request.getCategoryId());
        Budgets budget = Budgets.builder()
                .userId(userId)
                .categoryId(category.getId())
                .category(category.getName())
                .limitAmount(request.getLimitAmount())
                .spentAmount(BigDecimal.ZERO)
                .build();
        return mapToResponse(repository.save(budget));
    }

    public List<BudgetResponse> getBudgets() {
        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return repository.findAllByUserIdOrderByIdDesc(userId).stream().map(this::mapToResponse).toList();
    }

    public boolean checkBudgetLimit(Long id) {
        Budgets budget = requireOwned(id);
        return spentFor(budget).compareTo(budget.getLimitAmount()) >= 0;
    }

    public BudgetResponse updateBudget(Long id, BudgetRequest request) {
        Budgets budget = requireOwned(id);
        Categories category = requireCategory(request.getCategoryId());
        budget.setCategoryId(category.getId());
        budget.setCategory(category.getName());
        budget.setLimitAmount(request.getLimitAmount());
        return mapToResponse(repository.save(budget));
    }

    public void deleteBudget(Long id) {
        repository.delete(requireOwned(id));
    }

    public BudgetResponse getBudgetById(Long id) {
        return mapToResponse(requireOwned(id));
    }

    private Budgets requireOwned(Long id) {
        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return repository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Budget not found"));
    }

    private Categories requireCategory(Long id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found."));
    }

    private BigDecimal spentFor(Budgets budget) {
        return expenseRepository.findAllByUserIdAndCategoryId(budget.getUserId(), budget.getCategoryId())
                .stream().map(Expense::getAmount).reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private BudgetResponse mapToResponse(Budgets budget) {
        BigDecimal spent = spentFor(budget);
        return BudgetResponse.builder()
                .id(budget.getId())
                .userId(budget.getUserId())
                .categoryId(budget.getCategoryId())
                .category(budget.getCategory())
                .limitAmount(budget.getLimitAmount())
                .spentAmount(spent)
                .remainingAmount(budget.getLimitAmount().subtract(spent))
                .build();
    }
}
