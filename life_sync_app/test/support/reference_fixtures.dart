import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/finance/data/models/finance_models.dart';
import 'package:life_sync_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:life_sync_app/features/focus/data/models/focus_session.dart';
import 'package:life_sync_app/features/focus/domain/repositories/focus_repository.dart';
import 'package:life_sync_app/features/focus/presentation/controllers/focus_controller.dart';
import 'package:life_sync_app/features/goals/data/models/goal_models.dart';
import 'package:life_sync_app/features/goals/domain/repositories/goal_repository.dart';

class MemoryStore implements SecureKeyValueStore {
  final values = <String, String>{};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }
}

class TestClock implements FocusClock {
  TestClock(this.date);
  DateTime date;
  void advance(Duration duration) => date = date.add(duration);
  @override
  DateTime now() => date;
}

class TestFocusRepository implements FocusRepository {
  final sessions = <FocusSession>[];
  @override
  Future<List<FocusSession>> readAll() async => [...sessions];
  @override
  Future<FocusSession> create(FocusSession session) async {
    final created = session.copyWith(id: sessions.length + 1);
    sessions.add(created);
    return created;
  }
}

class TestFinanceRepository implements FinanceRepository {
  bool empty = false;
  bool fail = false;
  final anchor = DateTime(2026, 9, 1);
  @override
  Future<ApiResult<List<FinanceCategoryModel>>> getCategories() async =>
      const ApiSuccess([
        FinanceCategoryModel(id: 1, name: 'Salary', active: true),
        FinanceCategoryModel(id: 2, name: 'Food', active: true),
        FinanceCategoryModel(id: 3, name: 'Transport', active: true),
      ]);
  @override
  Future<ApiResult<List<BudgetModel>>> getBudgets() async =>
      const ApiSuccess([]);
  @override
  Future<ApiResult<List<FinanceEntryModel>>> getEntries(
    FinanceEntryType type, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (fail) {
      return const ApiFailure(
        ApiException(
          type: ApiFailureType.network,
          message: 'Test connection unavailable',
        ),
      );
    }
    if (empty) return const ApiSuccess([]);
    final entries = <FinanceEntryModel>[
      for (var index = 0; index < 10; index++)
        FinanceEntryModel(
          id: index + 1,
          userId: 1,
          categoryId: type == FinanceEntryType.income
              ? 1
              : index.isEven
              ? 2
              : 3,
          title: 'Test entry',
          amount: MoneyAmount.parse(
            type == FinanceEntryType.income ? '125.50' : '25.25',
          ),
          date: DateTime(
            anchor.year,
            anchor.month - (index >= 8 ? 1 : 0),
            (index % 8) * 3 + 1,
          ),
          type: type,
        ),
    ];
    return ApiSuccess(
      entries
          .where(
            (entry) =>
                (startDate == null || !entry.date.isBefore(startDate)) &&
                (endDate == null || !entry.date.isAfter(endDate)),
          )
          .toList(),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestGoalRepository implements GoalRepository {
  final goals = <GoalModel>[];
  final milestones = <GoalMilestoneModel>[];
  bool failNextMilestone = false;
  int createCalls = 0;
  @override
  Future<ApiResult<List<GoalModel>>> getGoals() async => ApiSuccess([...goals]);
  @override
  Future<ApiResult<List<GoalMilestoneModel>>> getMilestones(int goalId) async =>
      ApiSuccess(milestones.where((item) => item.goalId == goalId).toList());
  @override
  Future<ApiResult<List<GoalScheduleModel>>> getSchedules(int goalId) async =>
      const ApiSuccess([]);
  @override
  Future<ApiResult<GoalModel>> createGoal({
    required String title,
    String? description,
    required MoneyAmount targetAmount,
    required MoneyAmount currentAmount,
    required DateTime deadline,
  }) async {
    createCalls++;
    final goal = GoalModel(
      id: goals.length + 1,
      userId: 1,
      title: title,
      description: description,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      completed: false,
      archived: false,
      deadline: deadline,
      createdAt: DateTime.now(),
    );
    goals.add(goal);
    return ApiSuccess(goal);
  }

  @override
  Future<ApiResult<GoalMilestoneModel>> createMilestone({
    required int goalId,
    required String title,
    required DateTime targetDate,
  }) async {
    if (failNextMilestone) {
      failNextMilestone = false;
      return const ApiFailure(
        ApiException(type: ApiFailureType.server, message: 'Test save failure'),
      );
    }
    final item = GoalMilestoneModel(
      id: milestones.length + 1,
      title: title,
      completed: false,
      targetDate: targetDate,
      goalId: goalId,
    );
    milestones.add(item);
    return ApiSuccess(item);
  }

  @override
  Future<ApiResult<GoalMilestoneModel>> updateMilestone({
    required int id,
    required String title,
    required DateTime targetDate,
  }) async {
    final index = milestones.indexWhere((item) => item.id == id);
    final old = milestones[index];
    final next = GoalMilestoneModel(
      id: id,
      title: title,
      completed: old.completed,
      targetDate: targetDate,
      goalId: old.goalId,
    );
    milestones[index] = next;
    return ApiSuccess(next);
  }

  @override
  Future<ApiResult<GoalMilestoneModel>> completeMilestone(int id) async {
    final index = milestones.indexWhere((item) => item.id == id);
    final old = milestones[index];
    final next = GoalMilestoneModel(
      id: id,
      title: old.title,
      completed: true,
      targetDate: old.targetDate,
      goalId: old.goalId,
    );
    milestones[index] = next;
    return ApiSuccess(next);
  }

  @override
  Future<ApiResult<void>> deleteMilestone(int id) async {
    milestones.removeWhere((item) => item.id == id);
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<void>> deleteGoal(int id) async {
    goals.removeWhere((item) => item.id == id);
    return const ApiSuccess(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
