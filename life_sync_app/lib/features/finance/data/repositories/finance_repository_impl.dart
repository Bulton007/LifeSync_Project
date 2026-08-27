import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/finance/data/datasources/finance_remote_data_source.dart';
import 'package:life_sync_app/features/finance/data/models/finance_models.dart';
import 'package:life_sync_app/features/finance/domain/repositories/finance_repository.dart';

final class FinanceRepositoryImpl implements FinanceRepository {
  const FinanceRepositoryImpl(this._remote);
  final FinanceRemoteDataSource _remote;
  @override
  Future<ApiResult<List<FinanceCategoryModel>>> getCategories() =>
      _remote.getCategories();
  @override
  Future<ApiResult<FinanceCategoryModel>> createCategory({
    required String name,
    String? description,
    String? icon,
    String? color,
  }) => _remote.createCategory(
    name: name,
    description: description,
    icon: icon,
    color: color,
  );
  @override
  Future<ApiResult<FinanceCategoryModel>> updateCategory({
    required int id,
    required String name,
    String? description,
    String? icon,
    String? color,
  }) => _remote.updateCategory(
    id: id,
    name: name,
    description: description,
    icon: icon,
    color: color,
  );
  @override
  Future<ApiResult<void>> deleteCategory(int id) => _remote.deleteCategory(id);
  @override
  Future<ApiResult<List<BudgetModel>>> getBudgets() => _remote.getBudgets();
  @override
  Future<ApiResult<BudgetModel>> createBudget({
    required FinanceCategoryModel category,
    required MoneyAmount limit,
  }) => _remote.createBudget(category: category, limit: limit);
  @override
  Future<ApiResult<BudgetModel>> updateBudget({
    required int id,
    required FinanceCategoryModel category,
    required MoneyAmount limit,
  }) => _remote.updateBudget(id: id, category: category, limit: limit);
  @override
  Future<ApiResult<void>> deleteBudget(int id) => _remote.deleteBudget(id);
  @override
  Future<ApiResult<List<FinanceEntryModel>>> getEntries(
    FinanceEntryType type, {
    DateTime? startDate,
    DateTime? endDate,
  }) => _remote.getEntries(type, startDate: startDate, endDate: endDate);
  @override
  Future<ApiResult<FinanceEntryModel>> createEntry({
    required FinanceEntryType type,
    required int categoryId,
    required String title,
    String? description,
    required MoneyAmount amount,
    required DateTime date,
  }) => _remote.createEntry(
    type: type,
    categoryId: categoryId,
    title: title,
    description: description,
    amount: amount,
    date: date,
  );
  @override
  Future<ApiResult<FinanceEntryModel>> updateEntry({
    required FinanceEntryModel entry,
    required int categoryId,
    required String title,
    String? description,
    required MoneyAmount amount,
    required DateTime date,
  }) => _remote.updateEntry(
    entry: entry,
    categoryId: categoryId,
    title: title,
    description: description,
    amount: amount,
    date: date,
  );
  @override
  Future<ApiResult<void>> deleteEntry(FinanceEntryModel entry) =>
      _remote.deleteEntry(entry);
}
