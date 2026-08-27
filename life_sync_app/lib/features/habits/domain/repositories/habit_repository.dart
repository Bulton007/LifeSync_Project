import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';

abstract interface class HabitRepository {
  Future<ApiResult<List<HabitModel>>> getHabits();
  Future<ApiResult<HabitModel>> createHabit({
    required String name,
    required String? description,
    required String frequency,
    required DateTime startDate,
    required DateTime? endDate,
  });
  Future<ApiResult<HabitModel>> updateHabit({
    required int habitId,
    required String name,
    required String? description,
    required String frequency,
    required DateTime startDate,
    required DateTime? endDate,
  });
  Future<ApiResult<void>> deleteHabit(int habitId);
  Future<ApiResult<HabitModel>> setActive(int habitId, bool active);
  Future<ApiResult<List<HabitLogModel>>> getLogs();
  Future<ApiResult<List<HabitLogModel>>> getHabitLogs(int habitId);
  Future<ApiResult<HabitLogModel>> recordCompletion({
    required int habitId,
    required DateTime date,
    String? note,
  });
}
