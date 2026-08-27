package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Income.IncomeRequest;
import com.lifesync_project.LifeSyncBackend.dto.Income.IncomeResponse;
import com.lifesync_project.LifeSyncBackend.entity.Income;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.IncomeRepository;
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
public class IncomeService {

    private final IncomeRepository incomeRepository;
    private final CategoryRepository categoryRepository;
    private final AuthenticatedUserService authenticatedUserService;

    /**
     * Create Income
     */
    public IncomeResponse createIncome(IncomeRequest request) {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        requireCategory(request.getCategoryId());
        Income income = Income.builder()
                .userId(userId)
                .categoryId(request.getCategoryId())
                .title(request.getTitle())
                .description(request.getDescription())
                .amount(request.getAmount())
                .incomeDate(request.getIncomeDate())
                .build();

        return mapToResponse(incomeRepository.save(income));
    }

    /**
     * Update Income
     */
    public IncomeResponse updateIncome(Long id,
                                       IncomeRequest request) {

        Income income = requireOwned(id);
        requireCategory(request.getCategoryId());

        income.setCategoryId(request.getCategoryId());
        income.setTitle(request.getTitle());
        income.setDescription(request.getDescription());
        income.setAmount(request.getAmount());
        income.setIncomeDate(request.getIncomeDate());

        return mapToResponse(incomeRepository.save(income));
    }

    /**
     * Delete Income
     */
    public void deleteIncome(Long id) {

        Income income = requireOwned(id);

        incomeRepository.delete(income);
    }

    /**
     * Get Income By Id
     */
    public IncomeResponse getIncomeById(Long id) {

        return mapToResponse(requireOwned(id));
    }

    /**
     * Get All Incomes
     */
    public List<IncomeResponse> getIncomes() {

        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return incomeRepository.findAllByUserIdOrderByIncomeDateDesc(userId)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    /**
     * Filter Income By Date
     */
    public List<IncomeResponse> filterIncomeByDate(
            LocalDate startDate,
            LocalDate endDate) {

        if (endDate.isBefore(startDate)) {
            throw new BadRequestException("End date cannot be before start date.");
        }
        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return incomeRepository
                .findByUserIdAndIncomeDateBetweenOrderByIncomeDateDesc(userId, startDate, endDate)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    /**
     * Mapper
     */
    private IncomeResponse mapToResponse(Income income) {

        return IncomeResponse.builder()
                .id(income.getId())
                .userId(income.getUserId())
                .categoryId(income.getCategoryId())
                .title(income.getTitle())
                .description(income.getDescription())
                .amount(income.getAmount())
                .incomeDate(income.getIncomeDate())
                .createdAt(income.getCreatedAt())
                .updatedAt(income.getUpdatedAt())
                .build();
    }

    private Income requireOwned(Long id) {
        Long userId = authenticatedUserService.requireCurrentUser().getId();
        return incomeRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Income not found"));
    }

    private void requireCategory(Long id) {
        if (!categoryRepository.existsById(id)) {
            throw new ResourceNotFoundException("Category not found.");
        }
    }

}
