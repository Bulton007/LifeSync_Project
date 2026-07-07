package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Budget.BudgetRequest;
import com.lifesync_project.LifeSyncBackend.dto.Budget.BudgetResponse;
import com.lifesync_project.LifeSyncBackend.entity.Budgets;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.BudgetRepository;
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

    public BudgetResponse createBudget(
            BudgetRequest request) {

        Budgets budget = Budgets.builder()
                .category(request.getCategory())
                .limitAmount(request.getLimitAmount())
                .spentAmount(BigDecimal.ZERO)
                .build();

        return mapToResponse(
                repository.save(budget));
    }

    public List<BudgetResponse> getBudgets() {

        return repository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public boolean checkBudgetLimit(
            Long id) {

        Budgets budget =
                repository.findById(id)
                        .orElseThrow(() ->
                                new ResourceNotFoundException(
                                        "Budget not found"));

        return budget.getSpentAmount()
                .compareTo(
                        budget.getLimitAmount()) >= 0;
    }
    private BudgetResponse mapToResponse(Budgets budget) {

        return BudgetResponse.builder()
                .id(budget.getId())
                .category(budget.getCategory())
                .limitAmount(budget.getLimitAmount())
                .spentAmount(budget.getSpentAmount())
                .remainingAmount(
                        budget.getLimitAmount()
                                .subtract(budget.getSpentAmount()))
                .build();
    }
    public BudgetResponse updateBudget(
            Long id,
            BudgetRequest request) {

        Budgets budget = repository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Budget not found"));

        budget.setCategory(request.getCategory());
        budget.setLimitAmount(request.getLimitAmount());

        return mapToResponse(
                repository.save(budget));
    }
    public void deleteBudget(Long id) {

        Budgets budget = repository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Budget not found"));

        repository.delete(budget);
    }
    public BudgetResponse getBudgetById(Long id) {

        Budgets budget = repository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Budget not found"));

        return mapToResponse(budget);
    }
}