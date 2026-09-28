import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/finance/data/models/finance_models.dart';
import 'package:life_sync_app/features/finance/presentation/models/finance_analytics.dart';

void main() {
  FinanceEntryModel entry(
    DateTime date,
    String amount,
    FinanceEntryType type,
  ) => FinanceEntryModel(
    id: 1,
    userId: 1,
    categoryId: 2,
    title: 'Test',
    amount: MoneyAmount.parse(amount),
    date: date,
    type: type,
  );
  test('leap month includes zero days and excludes adjacent months', () {
    final analytics = FinanceAnalytics(
      [
        entry(DateTime(2024, 2, 29), '0.10', FinanceEntryType.income),
        entry(DateTime(2024, 2, 1), '0.20', FinanceEntryType.income),
        entry(DateTime(2024, 3, 1), '100', FinanceEntryType.income),
      ],
      DateTime(2024, 2, 15),
      FinancePeriod.month,
    );
    expect(analytics.buckets(FinanceGrouping.daily), hasLength(29));
    expect(analytics.total(FinanceEntryType.income).toApiString(), '0.30');
    expect(
      analytics
          .values(FinanceEntryType.income, FinanceGrouping.weekly)
          .fold(MoneyAmount.zero(), (sum, amount) => sum + amount)
          .toApiString(),
      '0.30',
    );
  });
  test('calendar quarters and previous-year periods are correct', () {
    final analytics = FinanceAnalytics(
      [],
      DateTime(2026, 1, 15),
      FinancePeriod.quarter,
    );
    expect(analytics.start, DateTime(2026, 1, 1));
    expect(analytics.end, DateTime(2026, 4, 1));
    expect(analytics.previous.start, DateTime(2025, 10, 1));
    expect(analytics.buckets(FinanceGrouping.monthly), hasLength(3));
  });
  test('negative balance remains negative and categories total correctly', () {
    final analytics = FinanceAnalytics(
      [
        entry(DateTime(2026, 9, 1), '20', FinanceEntryType.income),
        entry(DateTime(2026, 9, 2), '35.50', FinanceEntryType.expense),
      ],
      DateTime(2026, 9),
      FinancePeriod.month,
    );
    expect(analytics.balance.toApiString(), '-15.50');
    expect(
      analytics.categories(FinanceEntryType.expense)[2]!.toApiString(),
      '35.50',
    );
  });
}
