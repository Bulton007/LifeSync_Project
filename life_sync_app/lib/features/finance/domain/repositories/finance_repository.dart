import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/finance/data/models/finance_models.dart';

abstract interface class FinanceRepository {
  Future<ApiResult<List<FinanceCategoryModel>>> getCategories();
  Future<ApiResult<FinanceCategoryModel>> createCategory({
    required String name,
    String? description,
    String? icon,
    String? color,
  });
  Future<ApiResult<FinanceCategoryModel>> updateCategory({
    required int id,
    required String name,
    String? description,
    String? icon,
    String? color,
  });
  Future<ApiResult<void>> deleteCategory(int id);
  Future<ApiResult<List<BudgetModel>>> getBudgets();
  Future<ApiResult<BudgetModel>> createBudget({
    required FinanceCategoryModel category,
    required MoneyAmount limit,
  });
  Future<ApiResult<BudgetModel>> updateBudget({
    required int id,
    required FinanceCategoryModel category,
    required MoneyAmount limit,
  });
  Future<ApiResult<void>> deleteBudget(int id);
  Future<ApiResult<List<FinanceEntryModel>>> getEntries(
    FinanceEntryType type, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<ApiResult<FinanceEntryModel>> createEntry({
    required FinanceEntryType type,
    required int categoryId,
    required String title,
    String? description,
    required MoneyAmount amount,
    required DateTime date,
  });
  Future<ApiResult<FinanceEntryModel>> updateEntry({
    required FinanceEntryModel entry,
    required int categoryId,
    required String title,
    String? description,
    required MoneyAmount amount,
    required DateTime date,
  });
  Future<ApiResult<void>> deleteEntry(FinanceEntryModel entry);
}
