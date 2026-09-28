import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/finance/data/models/finance_models.dart';

enum FinancePeriod { month, quarter, year }

enum FinanceGrouping { daily, weekly, monthly }

class FinanceAnalytics {
  FinanceAnalytics(this.entries, this.anchor, this.period);
  final List<FinanceEntryModel> entries;
  final DateTime anchor;
  final FinancePeriod period;
  int get monthCount => switch (period) {
    FinancePeriod.month => 1,
    FinancePeriod.quarter => 3,
    FinancePeriod.year => 12,
  };
  DateTime get start => switch (period) {
    FinancePeriod.month => DateTime(anchor.year, anchor.month),
    FinancePeriod.quarter => DateTime(
      anchor.year,
      ((anchor.month - 1) ~/ 3) * 3 + 1,
    ),
    FinancePeriod.year => DateTime(anchor.year),
  };
  DateTime get end => DateTime(start.year, start.month + monthCount);
  FinanceAnalytics get previous => FinanceAnalytics(
    entries,
    DateTime(start.year, start.month - monthCount),
    period,
  );
  List<FinanceEntryModel> get selected => entries
      .where((entry) => !entry.date.isBefore(start) && entry.date.isBefore(end))
      .toList();
  MoneyAmount total(FinanceEntryType type) => selected
      .where((entry) => entry.type == type)
      .fold(MoneyAmount.zero(), (sum, entry) => sum + entry.amount);
  MoneyAmount get balance =>
      total(FinanceEntryType.income) - total(FinanceEntryType.expense);
  Map<int, MoneyAmount> categories(FinanceEntryType type) {
    final totals = <int, MoneyAmount>{};
    for (final entry in selected.where((entry) => entry.type == type)) {
      totals[entry.categoryId] =
          (totals[entry.categoryId] ?? MoneyAmount.zero()) + entry.amount;
    }
    return totals;
  }

  List<DateTime> buckets(FinanceGrouping grouping) {
    final result = <DateTime>[];
    var cursor = start;
    while (cursor.isBefore(end)) {
      result.add(cursor);
      cursor = switch (grouping) {
        FinanceGrouping.daily => DateTime(
          cursor.year,
          cursor.month,
          cursor.day + 1,
        ),
        FinanceGrouping.weekly => DateTime(
          cursor.year,
          cursor.month,
          cursor.day + 7,
        ),
        FinanceGrouping.monthly => DateTime(cursor.year, cursor.month + 1),
      };
    }
    return result;
  }

  List<MoneyAmount> values(FinanceEntryType type, FinanceGrouping grouping) {
    final starts = buckets(grouping);
    return List.generate(starts.length, (index) {
      final until = index + 1 < starts.length ? starts[index + 1] : end;
      return selected
          .where(
            (entry) =>
                entry.type == type &&
                !entry.date.isBefore(starts[index]) &&
                entry.date.isBefore(until),
          )
          .fold(MoneyAmount.zero(), (sum, entry) => sum + entry.amount);
    });
  }
}
