import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/habits/data/datasources/habit_remote_data_source.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';
import 'package:life_sync_app/features/habits/domain/repositories/habit_repository.dart';

final class HabitRepositoryImpl implements HabitRepository {
  const HabitRepositoryImpl(this._remote);
  final HabitRemoteDataSource _remote;

  @override
  Future<ApiResult<List<HabitModel>>> getHabits() => _remote.getHabits();

  @override
  Future<ApiResult<HabitModel>> createHabit({
    required String name,
    required String? description,
    required String frequency,
    required DateTime startDate,
    required DateTime? endDate,
  }) => _remote.createHabit(
    name: name,
    description: description,
    frequency: frequency,
    startDate: startDate,
    endDate: endDate,
  );

  @override
  Future<ApiResult<HabitModel>> updateHabit({
    required int habitId,
    required String name,
    required String? description,
    required String frequency,
    required DateTime startDate,
    required DateTime? endDate,
  }) => _remote.updateHabit(
    habitId: habitId,
    name: name,
    description: description,
    frequency: frequency,
    startDate: startDate,
    endDate: endDate,
  );

  @override
  Future<ApiResult<void>> deleteHabit(int habitId) =>
      _remote.deleteHabit(habitId);

  @override
  Future<ApiResult<HabitModel>> setActive(int habitId, bool active) =>
      _remote.setActive(habitId, active);

  @override
  Future<ApiResult<List<HabitLogModel>>> getLogs() => _remote.getLogs();

  @override
  Future<ApiResult<List<HabitLogModel>>> getHabitLogs(int habitId) =>
      _remote.getHabitLogs(habitId);

  @override
  Future<ApiResult<HabitLogModel>> recordCompletion({
    required int habitId,
    required DateTime date,
    String? note,
  }) => _remote.recordCompletion(habitId: habitId, date: date, note: note);
}
