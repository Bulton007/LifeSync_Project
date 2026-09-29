package com.lifesync_project.LifeSyncBackend;

import com.lifesync_project.LifeSyncBackend.entity.Budgets;
import com.lifesync_project.LifeSyncBackend.entity.Notifications;
import com.lifesync_project.LifeSyncBackend.repository.BudgetRepository;
import com.lifesync_project.LifeSyncBackend.repository.ExpenseRepository;
import com.lifesync_project.LifeSyncBackend.repository.NotificationRepository;
import com.lifesync_project.LifeSyncBackend.services.BudgetAlertService;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import java.math.BigDecimal;
import java.util.List;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

class BudgetAlertServiceTest {
    private final BudgetRepository budgets = mock(BudgetRepository.class);
    private final NotificationRepository notifications = mock(NotificationRepository.class);
    private final BudgetAlertService service = new BudgetAlertService(budgets, mock(ExpenseRepository.class), notifications);

    private void setup() {
        when(budgets.findAllByUserIdOrderByIdDesc(1L)).thenReturn(List.of(
                Budgets.builder().id(7L).userId(1L).categoryId(3L).category("Food")
                        .limitAmount(new BigDecimal("100")).build()));
    }

    @Test
    void createsWarningAndLimitAlertsOnlyAtCrossings() {
        setup();
        service.recordCrossings(1L, 3L, new BigDecimal("79"), new BigDecimal("80"));
        service.recordCrossings(1L, 3L, new BigDecimal("80"), new BigDecimal("90"));
        service.recordCrossings(1L, 3L, new BigDecimal("90"), new BigDecimal("100"));
        service.recordCrossings(1L, 3L, new BigDecimal("100"), new BigDecimal("110"));
        var captured = ArgumentCaptor.forClass(Notifications.class);
        verify(notifications, times(2)).save(captured.capture());
        assertEquals("BUDGET_WARNING", captured.getAllValues().get(0).getType());
        assertEquals("BUDGET_LIMIT", captured.getAllValues().get(1).getType());
        assertEquals(1L, captured.getValue().getUserId());
    }

    @Test
    void ignoresOtherCategoriesAndDecreases() {
        setup();
        service.recordCrossings(1L, 4L, BigDecimal.ZERO, new BigDecimal("200"));
        service.recordCrossings(1L, 3L, new BigDecimal("200"), BigDecimal.ZERO);
        verifyNoInteractions(notifications);
    }

    @Test
    void jumpingBothThresholdsCreatesOnlyLimitAlert() {
        setup();
        service.recordCrossings(1L, 3L, BigDecimal.ZERO, new BigDecimal("200"));
        var captured = ArgumentCaptor.forClass(Notifications.class);
        verify(notifications).save(captured.capture());
        assertEquals("BUDGET_LIMIT", captured.getValue().getType());
    }
}
