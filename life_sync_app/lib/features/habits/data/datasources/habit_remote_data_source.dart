import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/utils/api_date_codec.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';

final class HabitRemoteDataSource {
  const HabitRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResult<List<HabitModel>>> getHabits() =>
      _apiClient.get<List<HabitModel>>(
        '/api/habits',
        decoder: (data) => (data! as List)
            .map(
              (item) =>
                  HabitModel.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList(growable: false),
      );

  Future<ApiResult<HabitModel>> createHabit({
    required String name,
    required String? description,
    required String frequency,
    required DateTime startDate,
    required DateTime? endDate,
  }) => _apiClient.post<HabitModel>(
    '/api/habits',
    data: _habitRequest(
      name: name,
      description: description,
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
    ),
    decoder: _decodeHabit,
  );

  Future<ApiResult<HabitModel>> updateHabit({
    required int habitId,
    required String name,
    required String? description,
    required String frequency,
    required DateTime startDate,
    required DateTime? endDate,
  }) => _apiClient.put<HabitModel>(
    '/api/habits/$habitId',
    data: _habitRequest(
      name: name,
      description: description,
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
    ),
    decoder: _decodeHabit,
  );

  Future<ApiResult<void>> deleteHabit(int habitId) =>
      _apiClient.delete<void>('/api/habits/$habitId', decoder: (_) {});

  Future<ApiResult<HabitModel>> setActive(int habitId, bool active) =>
      _apiClient.patch<HabitModel>(
        '/api/habits/$habitId/${active ? 'resume' : 'pause'}',
        decoder: _decodeHabit,
      );

  Future<ApiResult<List<HabitLogModel>>> getLogs() =>
      _apiClient.get<List<HabitLogModel>>(
        '/api/habit-logs',
        decoder: (data) => (data! as List)
            .map(
              (item) => HabitLogModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(growable: false),
      );

  Future<ApiResult<List<HabitLogModel>>> getHabitLogs(int habitId) =>
      _apiClient.get<List<HabitLogModel>>(
        '/api/habit-logs/habit/$habitId',
        decoder: (data) => (data! as List)
            .map(
              (item) => HabitLogModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(growable: false),
      );

  Future<ApiResult<HabitLogModel>> recordCompletion({
    required int habitId,
    required DateTime date,
    String? note,
  }) => _apiClient.post<HabitLogModel>(
    '/api/habit-logs',
    data: {
      'habitId': habitId,
      'completedDate': ApiDateCodec.encodeDate(date),
      'note': note?.trim() ?? '',
    },
    decoder: _decodeLog,
  );

  static Map<String, dynamic> _habitRequest({
    required String name,
    required String? description,
    required String frequency,
    required DateTime startDate,
    required DateTime? endDate,
  }) => {
    'name': name.trim(),
    'description': description?.trim(),
    'frequency': frequency,
    'startDate': ApiDateCodec.encodeDate(startDate),
    'endDate': endDate == null ? null : ApiDateCodec.encodeDate(endDate),
  };

  static HabitModel _decodeHabit(Object? data) =>
      HabitModel.fromJson(Map<String, dynamic>.from(data! as Map));

  static HabitLogModel _decodeLog(Object? data) =>
      HabitLogModel.fromJson(Map<String, dynamic>.from(data! as Map));
}
