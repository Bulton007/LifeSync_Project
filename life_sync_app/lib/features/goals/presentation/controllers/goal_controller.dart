import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/goals/data/models/goal_models.dart';
import 'package:life_sync_app/features/goals/domain/repositories/goal_repository.dart';

final class GoalController extends GetxController {
  GoalController(this._repository);
  final GoalRepository _repository;
  final state = const AsyncViewState<List<GoalModel>>.initial().obs;
  final milestones = <int, List<GoalMilestoneModel>>{}.obs;
  final schedules = <int, List<GoalScheduleModel>>{}.obs;
  final detailsLoading = <int>{}.obs;
  final isSubmitting = false.obs;
  final errorMessage = RxnString();

  List<GoalModel> get goals => state.value.data ?? const [];
  List<GoalModel> get activeGoals =>
      goals.where((goal) => !goal.completed && !goal.archived).toList();
  int get completedCount => goals.where((goal) => goal.completed).length;
  int get archivedCount => goals.where((goal) => goal.archived).length;
  double get overallProgress => goals.isEmpty
      ? 0
      : goals.map((goal) => goal.progress).reduce((a, b) => a + b) /
            goals.length;

  @override
  void onInit() {
    super.onInit();
    loadGoals();
  }

  Future<void> loadGoals({bool refresh = false}) async {
    final previous = state.value.data;
    state.value = refresh && previous != null
        ? AsyncViewState.refreshing(previous)
        : const AsyncViewState.loading();
    final result = await _repository.getGoals();
    result.when(
      success: (items) {
        state.value = items.isEmpty
            ? const AsyncViewState.empty()
            : AsyncViewState.success(items);
        for (final goal in items) {
          loadDetails(goal.id);
        }
      },
      failure: (error) =>
          state.value = AsyncViewState.error(error, previousData: previous),
    );
  }

  Future<void> loadDetails(int goalId) async {
    if (detailsLoading.contains(goalId)) return;
    detailsLoading.add(goalId);
    errorMessage.value = null;
    try {
      final results = await Future.wait([
        _repository.getMilestones(goalId),
        _repository.getSchedules(goalId),
      ]);
      (results[0] as ApiResult<List<GoalMilestoneModel>>).when(
        success: (items) => milestones[goalId] = items,
        failure: _setError,
      );
      (results[1] as ApiResult<List<GoalScheduleModel>>).when(
        success: (items) => schedules[goalId] = items,
        failure: _setError,
      );
    } finally {
      detailsLoading.remove(goalId);
    }
  }

  Future<bool> createGoal({
    required String title,
    String? description,
    required MoneyAmount targetAmount,
    required MoneyAmount currentAmount,
    required DateTime deadline,
  }) => _mutateGoal(
    () => _repository.createGoal(
      title: title.trim(),
      description: _empty(description),
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      deadline: deadline,
    ),
    (goal) => [goal, ...goals],
  );
  Future<bool> updateGoal({
    required GoalModel goal,
    required String title,
    String? description,
    required MoneyAmount targetAmount,
    required MoneyAmount currentAmount,
    required DateTime deadline,
  }) => _mutateGoal(
    () => _repository.updateGoal(
      id: goal.id,
      title: title.trim(),
      description: _empty(description),
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      deadline: deadline,
    ),
    (updated) => _replaceGoal(updated),
  );
  Future<bool> completeGoal(GoalModel goal) =>
      _mutateGoal(() => _repository.completeGoal(goal.id), _replaceGoal);
  Future<bool> archiveGoal(GoalModel goal) =>
      _mutateGoal(() => _repository.archiveGoal(goal.id), _replaceGoal);

  Future<bool> deleteGoal(int id) async {
    if (!_begin()) return false;
    try {
      return (await _repository.deleteGoal(id)).when(
        success: (_) {
          milestones.remove(id);
          schedules.remove(id);
          _setGoals(goals.where((goal) => goal.id != id).toList());
          return true;
        },
        failure: _failure,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> createMilestone(int goalId, String title, DateTime date) =>
      _mutateMilestone(
        goalId,
        () => _repository.createMilestone(
          goalId: goalId,
          title: title.trim(),
          targetDate: date,
        ),
        (item, items) => [...items, item],
      );
  Future<bool> updateMilestone(
    GoalMilestoneModel milestone,
    String title,
    DateTime date,
  ) => _mutateMilestone(
    milestone.goalId,
    () => _repository.updateMilestone(
      id: milestone.id,
      title: title.trim(),
      targetDate: date,
    ),
    (item, items) => [
      for (final old in items)
        if (old.id == item.id) item else old,
    ],
  );
  Future<bool> completeMilestone(GoalMilestoneModel milestone) =>
      _mutateMilestone(
        milestone.goalId,
        () => _repository.completeMilestone(milestone.id),
        (item, items) => [
          for (final old in items)
            if (old.id == item.id) item else old,
        ],
      );
  Future<bool> deleteMilestone(GoalMilestoneModel milestone) async {
    if (!_begin()) return false;
    try {
      return (await _repository.deleteMilestone(milestone.id)).when(
        success: (_) {
          milestones[milestone.goalId] = [...?milestones[milestone.goalId]]
            ..removeWhere((item) => item.id == milestone.id);
          return true;
        },
        failure: _failure,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> createSchedule(int goalId, DateTime date, MoneyAmount amount) =>
      _mutateSchedule(
        goalId,
        () => _repository.createSchedule(
          goalId: goalId,
          scheduleDate: date,
          amount: amount,
        ),
        (item, items) => [...items, item],
      );
  Future<bool> completeSchedule(GoalScheduleModel schedule) => _mutateSchedule(
    schedule.goalId,
    () => _repository.completeSchedule(schedule.goalScheduleId),
    (item, items) => [
      for (final old in items)
        if (old.goalScheduleId == item.goalScheduleId) item else old,
    ],
    refreshGoals: true,
  );
  Future<bool> deleteSchedule(GoalScheduleModel schedule) async {
    if (!_begin()) return false;
    try {
      return (await _repository.deleteSchedule(schedule.goalScheduleId)).when(
        success: (_) {
          schedules[schedule.goalId] = [...?schedules[schedule.goalId]]
            ..removeWhere(
              (item) => item.goalScheduleId == schedule.goalScheduleId,
            );
          return true;
        },
        failure: _failure,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> _mutateGoal(
    Future<ApiResult<GoalModel>> Function() operation,
    List<GoalModel> Function(GoalModel) update,
  ) async {
    if (!_begin()) return false;
    try {
      return (await operation()).when(
        success: (goal) {
          _setGoals(update(goal));
          return true;
        },
        failure: _failure,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> _mutateMilestone(
    int goalId,
    Future<ApiResult<GoalMilestoneModel>> Function() operation,
    List<GoalMilestoneModel> Function(
      GoalMilestoneModel,
      List<GoalMilestoneModel>,
    )
    update,
  ) async {
    if (!_begin()) return false;
    try {
      return (await operation()).when(
        success: (item) {
          milestones[goalId] = update(item, milestones[goalId] ?? const []);
          return true;
        },
        failure: _failure,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> _mutateSchedule(
    int goalId,
    Future<ApiResult<GoalScheduleModel>> Function() operation,
    List<GoalScheduleModel> Function(GoalScheduleModel, List<GoalScheduleModel>)
    update, {
    bool refreshGoals = false,
  }) async {
    if (!_begin()) return false;
    try {
      return (await operation()).when(
        success: (item) {
          schedules[goalId] = update(item, schedules[goalId] ?? const []);
          if (refreshGoals) loadGoals(refresh: true);
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
    _setError(error);
    return false;
  }

  void _setError(ApiException error) => errorMessage.value = error.message;
  List<GoalModel> _replaceGoal(GoalModel updated) => [
    for (final goal in goals)
      if (goal.id == updated.id) updated else goal,
  ];
  void _setGoals(List<GoalModel> items) => state.value = items.isEmpty
      ? const AsyncViewState.empty()
      : AsyncViewState.success(items);
  static String? _empty(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
