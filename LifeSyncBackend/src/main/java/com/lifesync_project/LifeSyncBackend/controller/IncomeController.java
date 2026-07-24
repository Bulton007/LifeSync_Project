package com.lifesync_project.LifeSyncBackend.controller;

import com.lifesync_project.LifeSyncBackend.dto.Income.IncomeRequest;
import com.lifesync_project.LifeSyncBackend.dto.Income.IncomeResponse;
import com.lifesync_project.LifeSyncBackend.services.IncomeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/incomes")
@RequiredArgsConstructor
public class IncomeController {

    private final IncomeService incomeService;

    @PostMapping
    public IncomeResponse createIncome(
            @Valid @RequestBody IncomeRequest request) {

        return incomeService.createIncome(request);
    }

    @PutMapping("/{id}")
    public IncomeResponse updateIncome(
            @PathVariable Long id,
            @Valid @RequestBody IncomeRequest request) {

        return incomeService.updateIncome(id, request);
    }

    @DeleteMapping("/{id}")
    public void deleteIncome(@PathVariable Long id) {

        incomeService.deleteIncome(id);
    }

    @GetMapping("/{id}")
    public IncomeResponse getIncomeById(
            @PathVariable Long id) {

        return incomeService.getIncomeById(id);
    }

    @GetMapping
    public List<IncomeResponse> getIncomes() {

        return incomeService.getIncomes();
    }

    @GetMapping("/filter")
    public List<IncomeResponse> filterIncomeByDate(

            @RequestParam LocalDate startDate,

            @RequestParam LocalDate endDate) {

        return incomeService.filterIncomeByDate(
                startDate,
                endDate);
    }

}