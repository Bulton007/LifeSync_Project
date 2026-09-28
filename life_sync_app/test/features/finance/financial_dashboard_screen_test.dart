import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:life_sync_app/features/finance/presentation/controllers/finance_controller.dart';
import 'package:life_sync_app/features/finance/presentation/pages/financial_dashboard_screen.dart';
import '../../support/reference_fixtures.dart';
import '../../support/reference_flows.dart';

void main() {
  tearDown(() => Get.reset());
  testWidgets('dashboard shows failures and retries without fake totals', (
    tester,
  ) async {
    final repository = TestFinanceRepository()..fail = true;
    Get.put<FinanceRepository>(repository);
    await tester.pumpWidget(
      referenceApp(FinancialDashboardScreen(initialDate: DateTime(2026, 9))),
    );
    await tester.pumpAndSettle();
    expect(find.text('Test connection unavailable'), findsOneWidget);
    expect(find.text(r'$1004.00'), findsNothing);
    repository.fail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text(r'$1004.00'), findsOneWidget);
  });
  testWidgets('dashboard does not reset finance-management date filters', (
    tester,
  ) async {
    final repository = TestFinanceRepository();
    Get.put<FinanceRepository>(repository);
    final management = Get.put(FinanceController(repository));
    final start = DateTime(2026, 8, 1);
    final end = DateTime(2026, 8, 31);
    await management.setDateFilter(start, end);
    await tester.pumpWidget(
      referenceApp(FinancialDashboardScreen(initialDate: DateTime(2026, 9))),
    );
    await tester.pumpAndSettle();
    expect(find.text(r'$1004.00'), findsOneWidget);
    expect(management.filterStart.value, start);
    expect(management.filterEnd.value, end);
  });
}
