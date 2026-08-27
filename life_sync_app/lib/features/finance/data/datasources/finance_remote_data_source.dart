import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/utils/api_date_codec.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/finance/data/models/finance_models.dart';

final class FinanceRemoteDataSource {
  const FinanceRemoteDataSource(this._api);
  final ApiClient _api;
  Future<ApiResult<List<FinanceCategoryModel>>> getCategories() => _api.get(
    '/api/categories',
    decoder: (data) => _list(data, FinanceCategoryModel.fromJson),
  );
  Future<ApiResult<FinanceCategoryModel>> createCategory({
    required String name,
    String? description,
    String? icon,
    String? color,
  }) => _api.post(
    '/api/categories',
    data: {
      'name': name.trim(),
      'description': description?.trim(),
      'icon': icon,
      'color': color,
    },
    decoder: _category,
  );
  Future<ApiResult<FinanceCategoryModel>> updateCategory({
    required int id,
    required String name,
    String? description,
    String? icon,
    String? color,
  }) => _api.put(
    '/api/categories/$id',
    data: {
      'name': name.trim(),
      'description': description?.trim(),
      'icon': icon,
      'color': color,
    },
    decoder: _category,
  );
  Future<ApiResult<void>> deleteCategory(int id) =>
      _api.delete('/api/categories/$id', decoder: (_) {});

  Future<ApiResult<List<BudgetModel>>> getBudgets() => _api.get(
    '/api/budgets',
    decoder: (data) => _list(data, BudgetModel.fromJson),
  );
  Future<ApiResult<BudgetModel>> createBudget({
    required FinanceCategoryModel category,
    required MoneyAmount limit,
  }) => _api.post(
    '/api/budgets',
    data: {
      'categoryId': category.id,
      'category': category.name,
      'limitAmount': limit.toApiString(),
    },
    decoder: _budget,
  );
  Future<ApiResult<BudgetModel>> updateBudget({
    required int id,
    required FinanceCategoryModel category,
    required MoneyAmount limit,
  }) => _api.put(
    '/api/budgets/$id',
    data: {
      'categoryId': category.id,
      'category': category.name,
      'limitAmount': limit.toApiString(),
    },
    decoder: _budget,
  );
  Future<ApiResult<void>> deleteBudget(int id) =>
      _api.delete('/api/budgets/$id', decoder: (_) {});

  Future<ApiResult<List<FinanceEntryModel>>> getEntries(
    FinanceEntryType type, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final path = type == FinanceEntryType.income
        ? '/api/incomes'
        : '/api/expenses';
    final filtered = startDate != null && endDate != null;
    return _api.get(
      filtered ? '$path/filter' : path,
      queryParameters: filtered
          ? {
              'startDate': ApiDateCodec.encodeDate(startDate),
              'endDate': ApiDateCodec.encodeDate(endDate),
            }
          : null,
      decoder: (data) =>
          _list(data, (json) => FinanceEntryModel.fromJson(json, type)),
    );
  }

  Future<ApiResult<FinanceEntryModel>> createEntry({
    required FinanceEntryType type,
    required int categoryId,
    required String title,
    String? description,
    required MoneyAmount amount,
    required DateTime date,
  }) {
    final base = type == FinanceEntryType.income
        ? '/api/incomes'
        : '/api/expenses';
    return _api.post(
      base,
      data: _entryBody(type, categoryId, title, description, amount, date),
      decoder: (data) => FinanceEntryModel.fromJson(
        Map<String, dynamic>.from(data! as Map),
        type,
      ),
    );
  }

  Future<ApiResult<FinanceEntryModel>> updateEntry({
    required FinanceEntryModel entry,
    required int categoryId,
    required String title,
    String? description,
    required MoneyAmount amount,
    required DateTime date,
  }) {
    final base = entry.type == FinanceEntryType.income
        ? '/api/incomes'
        : '/api/expenses';
    return _api.put(
      '$base/${entry.id}',
      data: _entryBody(
        entry.type,
        categoryId,
        title,
        description,
        amount,
        date,
      ),
      decoder: (data) => FinanceEntryModel.fromJson(
        Map<String, dynamic>.from(data! as Map),
        entry.type,
      ),
    );
  }

  Future<ApiResult<void>> deleteEntry(FinanceEntryModel entry) {
    final base = entry.type == FinanceEntryType.income
        ? '/api/incomes'
        : '/api/expenses';
    return _api.delete('$base/${entry.id}', decoder: (_) {});
  }

  static Map<String, dynamic> _entryBody(
    FinanceEntryType type,
    int categoryId,
    String title,
    String? description,
    MoneyAmount amount,
    DateTime date,
  ) => {
    'categoryId': categoryId,
    'title': title.trim(),
    'description': description?.trim(),
    'amount': amount.toApiString(),
    type == FinanceEntryType.income ? 'incomeDate' : 'expenseDate':
        ApiDateCodec.encodeDate(date),
  };
  static FinanceCategoryModel _category(Object? data) =>
      FinanceCategoryModel.fromJson(Map<String, dynamic>.from(data! as Map));
  static BudgetModel _budget(Object? data) =>
      BudgetModel.fromJson(Map<String, dynamic>.from(data! as Map));
  static List<T> _list<T>(
    Object? data,
    T Function(Map<String, dynamic>) decoder,
  ) => (data! as List)
      .map((item) => decoder(Map<String, dynamic>.from(item as Map)))
      .toList(growable: false);
}
