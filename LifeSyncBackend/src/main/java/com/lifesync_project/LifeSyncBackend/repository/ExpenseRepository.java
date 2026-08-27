package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.Expense;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface ExpenseRepository extends JpaRepository<Expense, Long> {

    List<Expense> findByUserId(Long userId);

    List<Expense> findAllByUserIdOrderByExpenseDateDesc(Long userId);

    List<Expense> findAllByUserIdAndCategoryId(Long userId, Long categoryId);

    Optional<Expense> findByIdAndUserId(Long id, Long userId);

    boolean existsByCategoryId(Long categoryId);

    List<Expense> findByExpenseDateBetween(
            LocalDate startDate,
            LocalDate endDate);

    List<Expense> findByUserIdAndExpenseDateBetweenOrderByExpenseDateDesc(
            Long userId, LocalDate startDate, LocalDate endDate);

}
