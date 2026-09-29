package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.entity.Notifications;
import com.lifesync_project.LifeSyncBackend.repository.BudgetRepository;
import com.lifesync_project.LifeSyncBackend.repository.ExpenseRepository;
import com.lifesync_project.LifeSyncBackend.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class BudgetAlertService {
    private final BudgetRepository budgets;
    private final ExpenseRepository expenses;
    private final NotificationRepository notifications;

    public BigDecimal total(Long userId, Long categoryId) {
        return expenses.findAllByUserIdAndCategoryId(userId, categoryId).stream()
                .map(expense -> expense.getAmount()).reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public void recordCrossings(Long userId, Long categoryId, BigDecimal before, BigDecimal after) {
        if (after.compareTo(before) <= 0) return;
        for (var budget : budgets.findAllByUserIdOrderByIdDesc(userId)) {
            if (!Objects.equals(categoryId, budget.getCategoryId()) || budget.getLimitAmount() == null
                    || budget.getLimitAmount().signum() <= 0) continue;
            var limit = budget.getLimitAmount();
            var warning = limit.multiply(new BigDecimal("0.80"));
            String title;
            String type;
            if (before.compareTo(limit) < 0 && after.compareTo(limit) >= 0) {
                title = "Budget limit reached";
                type = "BUDGET_LIMIT";
            } else if (before.compareTo(warning) < 0 && after.compareTo(warning) >= 0) {
                title = "Budget nearly used";
                type = "BUDGET_WARNING";
            } else continue;
            notifications.save(Notifications.builder().userId(userId).title(title).type(type)
                    .message("Spending for " + budget.getCategory() + " is " + after.toPlainString()
                            + " of your " + limit.toPlainString() + " budget. Review your expenses.")
                    .build());
        }
    }
}
