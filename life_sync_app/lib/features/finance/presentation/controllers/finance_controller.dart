import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/finance/data/models/finance_models.dart';
import 'package:life_sync_app/features/finance/domain/repositories/finance_repository.dart';

final class FinanceController extends GetxController {
  FinanceController(this._repository);
  final FinanceRepository _repository;
  final state = const AsyncViewState<FinanceData>.initial().obs;
  final isSubmitting = false.obs;
  final errorMessage = RxnString();
  final filterStart = Rxn<DateTime>();
  final filterEnd = Rxn<DateTime>();

  FinanceData get data =>
      state.value.data ??
      const FinanceData(categories: [], budgets: [], incomes: [], expenses: []);
  MoneyAmount get incomeTotal =>
      data.incomes.fold(MoneyAmount.zero(), (sum, entry) => sum + entry.amount);
  MoneyAmount get expenseTotal => data.expenses.fold(
    MoneyAmount.zero(),
    (sum, entry) => sum + entry.amount,
  );
  MoneyAmount get balance => incomeTotal - expenseTotal;
  List<FinanceEntryModel> get history => data.history;
  FinanceCategoryModel? categoryFor(int id) =>
      data.categories.firstWhereOrNull((item) => item.id == id);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool refresh = false}) async {
    final previous = state.value.data;
    state.value = refresh && previous != null
        ? AsyncViewState.refreshing(previous)
        : const AsyncViewState.loading();
    final results = await Future.wait([
      _repository.getCategories(),
      _repository.getBudgets(),
      _repository.getEntries(
        FinanceEntryType.income,
        startDate: filterStart.value,
        endDate: filterEnd.value,
      ),
      _repository.getEntries(
        FinanceEntryType.expense,
        startDate: filterStart.value,
        endDate: filterEnd.value,
      ),
    ]);
    final categoryResult = results[0] as ApiResult<List<FinanceCategoryModel>>;
    final budgetResult = results[1] as ApiResult<List<BudgetModel>>;
    final incomeResult = results[2] as ApiResult<List<FinanceEntryModel>>;
    final expenseResult = results[3] as ApiResult<List<FinanceEntryModel>>;
    ApiException? error;
    for (final candidate in [
      categoryResult.errorOrNull,
      budgetResult.errorOrNull,
      incomeResult.errorOrNull,
      expenseResult.errorOrNull,
    ]) {
      if (candidate != null) {
        error = candidate;
        break;
      }
    }
    if (error != null) {
      state.value = AsyncViewState.error(error, previousData: previous);
      return;
    }
    final next = FinanceData(
      categories: categoryResult.dataOrNull!,
      budgets: budgetResult.dataOrNull!,
      incomes: incomeResult.dataOrNull!,
      expenses: expenseResult.dataOrNull!,
    );
    state.value =
        next.categories.isEmpty && next.budgets.isEmpty && next.history.isEmpty
        ? const AsyncViewState.empty()
        : AsyncViewState.success(next);
  }

  Future<void> setDateFilter(DateTime? start, DateTime? end) async {
    filterStart.value = start;
    filterEnd.value = end;
    await load();
  }

  Future<bool> createCategory(
    String name, {
    String? description,
    String? icon,
    String? color,
  }) => _mutate(
    () => _repository.createCategory(
      name: name,
      description: description,
      icon: icon,
      color: color,
    ),
    (item) => _setData(
      FinanceData(
        categories: [...data.categories, item],
        budgets: data.budgets,
        incomes: data.incomes,
        expenses: data.expenses,
      ),
    ),
  );
  Future<bool> updateCategory(
    FinanceCategoryModel category,
    String name, {
    String? description,
    String? icon,
    String? color,
  }) => _mutate(
    () => _repository.updateCategory(
      id: category.id,
      name: name,
      description: description,
      icon: icon,
      color: color,
    ),
    (item) => _setData(
      FinanceData(
        categories: [
          for (final old in data.categories)
            if (old.id == item.id) item else old,
        ],
        budgets: data.budgets,
        incomes: data.incomes,
        expenses: data.expenses,
      ),
    ),
  );
  Future<bool> deleteCategory(FinanceCategoryModel category) => _delete(
    () => _repository.deleteCategory(category.id),
    () => _setData(
      FinanceData(
        categories: data.categories
            .where((item) => item.id != category.id)
            .toList(),
        budgets: data.budgets,
        incomes: data.incomes,
        expenses: data.expenses,
      ),
    ),
  );

  Future<bool> createBudget(FinanceCategoryModel category, MoneyAmount limit) =>
      _mutate(
        () => _repository.createBudget(category: category, limit: limit),
        (item) => _setData(
          FinanceData(
            categories: data.categories,
            budgets: [item, ...data.budgets],
            incomes: data.incomes,
            expenses: data.expenses,
          ),
        ),
      );
  Future<bool> updateBudget(
    BudgetModel budget,
    FinanceCategoryModel category,
    MoneyAmount limit,
  ) => _mutate(
    () => _repository.updateBudget(
      id: budget.id,
      category: category,
      limit: limit,
    ),
    (item) => _setData(
      FinanceData(
        categories: data.categories,
        budgets: [
          for (final old in data.budgets)
            if (old.id == item.id) item else old,
        ],
        incomes: data.incomes,
        expenses: data.expenses,
      ),
    ),
  );
  Future<bool> deleteBudget(BudgetModel budget) => _delete(
    () => _repository.deleteBudget(budget.id),
    () => _setData(
      FinanceData(
        categories: data.categories,
        budgets: data.budgets.where((item) => item.id != budget.id).toList(),
        incomes: data.incomes,
        expenses: data.expenses,
      ),
    ),
  );

  Future<bool> createEntry({
    required FinanceEntryType type,
    required int categoryId,
    required String title,
    String? description,
    required MoneyAmount amount,
    required DateTime date,
  }) => _mutate(
    () => _repository.createEntry(
      type: type,
      categoryId: categoryId,
      title: title,
      description: description,
      amount: amount,
      date: date,
    ),
    (item) {
      final incomes = type == FinanceEntryType.income
          ? [item, ...data.incomes]
          : data.incomes;
      final expenses = type == FinanceEntryType.expense
          ? [item, ...data.expenses]
          : data.expenses;
      _setData(
        FinanceData(
          categories: data.categories,
          budgets: data.budgets,
          incomes: incomes,
          expenses: expenses,
        ),
      );
      load(refresh: true);
    },
  );
  Future<bool> updateEntry(
    FinanceEntryModel entry, {
    required int categoryId,
    required String title,
    String? description,
    required MoneyAmount amount,
    required DateTime date,
  }) => _mutate(
    () => _repository.updateEntry(
      entry: entry,
      categoryId: categoryId,
      title: title,
      description: description,
      amount: amount,
      date: date,
    ),
    (item) {
      final incomes = [
        for (final old in data.incomes)
          if (old.id == item.id && item.type == FinanceEntryType.income)
            item
          else
            old,
      ];
      final expenses = [
        for (final old in data.expenses)
          if (old.id == item.id && item.type == FinanceEntryType.expense)
            item
          else
            old,
      ];
      _setData(
        FinanceData(
          categories: data.categories,
          budgets: data.budgets,
          incomes: incomes,
          expenses: expenses,
        ),
      );
      load(refresh: true);
    },
  );
  Future<bool> deleteEntry(FinanceEntryModel entry) =>
      _delete(() => _repository.deleteEntry(entry), () {
        _setData(
          FinanceData(
            categories: data.categories,
            budgets: data.budgets,
            incomes: data.incomes
                .where(
                  (item) =>
                      !(entry.type == FinanceEntryType.income &&
                          item.id == entry.id),
                )
                .toList(),
            expenses: data.expenses
                .where(
                  (item) =>
                      !(entry.type == FinanceEntryType.expense &&
                          item.id == entry.id),
                )
                .toList(),
          ),
        );
        load(refresh: true);
      });

  Future<bool> _mutate<T>(
    Future<ApiResult<T>> Function() operation,
    void Function(T) update,
  ) async {
    if (!_begin()) return false;
    try {
      return (await operation()).when(
        success: (item) {
          update(item);
          return true;
        },
        failure: _failure,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> _delete(
    Future<ApiResult<void>> Function() operation,
    void Function() update,
  ) async {
    if (!_begin()) return false;
    try {
      return (await operation()).when(
        success: (_) {
          update();
          return true;
        },
        failure: _failure,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  bool _begin() {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    return true;
  }

  bool _failure(ApiException error) {
    errorMessage.value = error.message;
    return false;
  }

  void _setData(FinanceData value) => state.value =
      value.categories.isEmpty && value.budgets.isEmpty && value.history.isEmpty
      ? const AsyncViewState.empty()
      : AsyncViewState.success(value);
}
