import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/features/finance/data/models/finance_models.dart';

void main() {
  test('BudgetModel preserves exact monetary response strings', () {
    final budget = BudgetModel.fromJson({
      'id': 4,
      'userId': 9,
      'categoryId': 2,
      'category': 'Food',
      'limitAmount': '500.00',
      'spentAmount': '125.75',
      'remainingAmount': '374.25',
    });

    expect(budget.limitAmount.toApiString(), '500.00');
    expect(budget.spentAmount.toApiString(), '125.75');
    expect(budget.remainingAmount.toApiString(), '374.25');
    expect(budget.progress, closeTo(0.2515, 0.0001));
  });

  test('FinanceData merges income and expense history by date', () {
    final income = FinanceEntryModel.fromJson({
      'id': 1,
      'userId': 9,
      'categoryId': 2,
      'title': 'Salary',
      'amount': '1500.10',
      'incomeDate': '2026-08-01',
      'createdAt': '2026-08-01T08:00:00',
    }, FinanceEntryType.income);
    final expense = FinanceEntryModel.fromJson({
      'id': 1,
      'userId': 9,
      'categoryId': 2,
      'title': 'Groceries',
      'amount': '21.09',
      'expenseDate': '2026-08-02',
      'createdAt': '2026-08-02T08:00:00',
    }, FinanceEntryType.expense);

    final data = FinanceData(
      categories: const [],
      budgets: const [],
      incomes: [income],
      expenses: [expense],
    );

    expect(data.history, [expense, income]);
    expect(data.history.last.amount.toApiString(), '1500.10');
  });
}
