package com.lifesync_project.LifeSyncBackend.repository;

import com.lifesync_project.LifeSyncBackend.entity.Income;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface IncomeRepository extends JpaRepository<Income, Long> {

    List<Income> findByUserId(Long userId);

    List<Income> findAllByUserIdOrderByIncomeDateDesc(Long userId);

    Optional<Income> findByIdAndUserId(Long id, Long userId);

    boolean existsByCategoryId(Long categoryId);

    List<Income> findByIncomeDateBetween(
            LocalDate startDate,
            LocalDate endDate);

    List<Income> findByUserIdAndIncomeDateBetweenOrderByIncomeDateDesc(
            Long userId, LocalDate startDate, LocalDate endDate);

}
