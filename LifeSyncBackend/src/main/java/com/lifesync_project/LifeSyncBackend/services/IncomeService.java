package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Income.IncomeRequest;
import com.lifesync_project.LifeSyncBackend.dto.Income.IncomeResponse;
import com.lifesync_project.LifeSyncBackend.entity.Income;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.IncomeRepository;
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

    /**
     * Create Income
     */
    public IncomeResponse createIncome(IncomeRequest request) {

        Income income = Income.builder()
                .userId(request.getUserId())
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

        Income income = incomeRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Income not found"));

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

        Income income = incomeRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Income not found"));

        incomeRepository.delete(income);
    }

    /**
     * Get Income By Id
     */
    public IncomeResponse getIncomeById(Long id) {

        Income income = incomeRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Income not found"));

        return mapToResponse(income);
    }

    /**
     * Get All Incomes
     */
    public List<IncomeResponse> getIncomes() {

        return incomeRepository.findAll()
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

        return incomeRepository
                .findByIncomeDateBetween(startDate, endDate)
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

}