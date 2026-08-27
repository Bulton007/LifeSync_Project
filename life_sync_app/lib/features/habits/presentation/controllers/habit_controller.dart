import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';
import 'package:life_sync_app/features/habits/domain/repositories/habit_repository.dart';

final class HabitController extends GetxController {
  HabitController(this._repository);

  final HabitRepository _repository;
  final state = const AsyncViewState<List<HabitModel>>.initial().obs;
  final logs = <HabitLogModel>[].obs;
  final selectedDate = DateTime.now().obs;
  final isSubmitting = false.obs;
  final errorMessage = RxnString();

  List<HabitModel> get habits => state.value.data ?? const [];
  List<HabitModel> get scheduledHabits => habits
      .where((habit) => habit.isScheduledFor(selectedDate.value))
      .toList(growable: false);
  List<HabitModel> get todayHabits {
    final today = DateTime.now();
    return habits
        .where((habit) => habit.isScheduledFor(today))
        .toList(growable: false);
  }

  int get todayCompletedCount => todayHabits
      .where((habit) => isCompletedOn(habit.habitId, DateTime.now()))
      .length;

  @override
  void onInit() {
    super.onInit();
    loadHabits();
  }

  Future<void> loadHabits({bool refresh = false}) async {
    final previous = state.value.data;
    state.value = refresh && previous != null
        ? AsyncViewState<List<HabitModel>>.refreshing(previous)
        : const AsyncViewState<List<HabitModel>>.loading();
    final results = await Future.wait([
      _repository.getHabits(),
      _repository.getLogs(),
    ]);
    final habitsResult = results[0] as ApiResult<List<HabitModel>>;
    final logsResult = results[1] as ApiResult<List<HabitLogModel>>;
    habitsResult.when(
      success: (items) => state.value = items.isEmpty
          ? const AsyncViewState<List<HabitModel>>.empty()
          : AsyncViewState<List<HabitModel>>.success(items),
      failure: (error) => state.value = AsyncViewState<List<HabitModel>>.error(
        error,
        previousData: previous,
      ),
    );
    logsResult.when(
      success: logs.assignAll,
      failure: (error) => errorMessage.value = error.message,
    );
  }

  void selectDate(DateTime date) =>
      selectedDate.value = DateTime(date.year, date.month, date.day);

  bool isCompletedOn(int habitId, DateTime date) => logs.any(
    (log) =>
        log.habitId == habitId &&
        log.completed &&
        _sameDate(log.completedDate, date),
  );

  List<HabitLogModel> historyFor(int habitId) =>
      logs.where((log) => log.habitId == habitId).toList(growable: false)
        ..sort((a, b) => b.completedDate.compareTo(a.completedDate));

  Future<bool> createHabit({
    required String name,
    String? description,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
  }) => _mutateHabit(
    () => _repository.createHabit(
      name: name.trim(),
      description: _emptyToNull(description),
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
    ),
    (habit) => [habit, ...habits],
  );

  Future<bool> updateHabit({
    required HabitModel habit,
    required String name,
    String? description,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
  }) => _mutateHabit(
    () => _repository.updateHabit(
      habitId: habit.habitId,
      name: name.trim(),
      description: _emptyToNull(description),
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
    ),
    (updated) => [
      for (final item in habits)
        if (item.habitId == updated.habitId) updated else item,
    ],
  );

  Future<bool> setActive(HabitModel habit, bool active) => _mutateHabit(
    () => _repository.setActive(habit.habitId, active),
    (updated) => [
      for (final item in habits)
        if (item.habitId == updated.habitId) updated else item,
    ],
  );

  Future<bool> deleteHabit(int habitId) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.deleteHabit(habitId);
      return result.when(
        success: (_) {
          logs.removeWhere((log) => log.habitId == habitId);
          _setHabits(
            habits.where((habit) => habit.habitId != habitId).toList(),
          );
          return true;
        },
        failure: _recordFailure,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> recordCompletion(
    HabitModel habit,
    DateTime date, {
    String? note,
  }) async {
    if (isCompletedOn(habit.habitId, date)) return true;
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.recordCompletion(
        habitId: habit.habitId,
        date: date,
        note: note,
      );
      return result.when(
        success: (log) {
          logs.insert(0, log);
          if (_sameDate(date, DateTime.now())) loadHabits(refresh: true);
          return true;
        },
        failure: _recordFailure,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> _mutateHabit(
    Future<ApiResult<HabitModel>> Function() operation,
    List<HabitModel> Function(HabitModel) update,
  ) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final result = await operation();
      return result.when(
        success: (habit) {
          _setHabits(update(habit));
          return true;
        },
        failure: _recordFailure,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void _setHabits(List<HabitModel> items) => state.value = items.isEmpty
      ? const AsyncViewState<List<HabitModel>>.empty()
      : AsyncViewState<List<HabitModel>>.success(items);

  bool _recordFailure(ApiException error) {
    errorMessage.value = error.message;
    return false;
  }

  static String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
