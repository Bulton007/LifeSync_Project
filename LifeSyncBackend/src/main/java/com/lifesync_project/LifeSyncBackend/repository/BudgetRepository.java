package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.Budgets;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BudgetRepository extends JpaRepository<Budgets, Long> {
    List<Budgets> findAllByUserIdOrderByIdDesc(Long userId);
    Optional<Budgets> findByIdAndUserId(Long id, Long userId);
    boolean existsByCategoryId(Long categoryId);
}
