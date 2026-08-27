import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/utils/api_date_codec.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/goals/data/models/goal_models.dart';

final class GoalRemoteDataSource {
  const GoalRemoteDataSource(this._api);
  final ApiClient _api;

  Future<ApiResult<List<GoalModel>>> getGoals() => _api.get(
    '/api/goals',
    decoder: (data) => _list(data, GoalModel.fromJson),
  );
  Future<ApiResult<GoalModel>> createGoal({
    required String title,
    String? description,
    required MoneyAmount targetAmount,
    required MoneyAmount currentAmount,
    required DateTime deadline,
  }) => _api.post(
    '/api/goals',
    data: _goalBody(title, description, targetAmount, currentAmount, deadline),
    decoder: _goal,
  );
  Future<ApiResult<GoalModel>> updateGoal({
    required int id,
    required String title,
    String? description,
    required MoneyAmount targetAmount,
    required MoneyAmount currentAmount,
    required DateTime deadline,
  }) => _api.put(
    '/api/goals/$id',
    data: _goalBody(title, description, targetAmount, currentAmount, deadline),
    decoder: _goal,
  );
  Future<ApiResult<void>> deleteGoal(int id) =>
      _api.delete('/api/goals/$id', decoder: (_) {});
  Future<ApiResult<GoalModel>> completeGoal(int id) =>
      _api.patch('/api/goals/$id/complete', decoder: _goal);
  Future<ApiResult<GoalModel>> archiveGoal(int id) =>
      _api.patch('/api/goals/$id/archive', decoder: _goal);

  Future<ApiResult<List<GoalMilestoneModel>>> getMilestones(int goalId) =>
      _api.get(
        '/api/goal-milestones/goal/$goalId',
        decoder: (data) => _list(data, GoalMilestoneModel.fromJson),
      );
  Future<ApiResult<GoalMilestoneModel>> createMilestone({
    required int goalId,
    required String title,
    required DateTime targetDate,
  }) => _api.post(
    '/api/goal-milestones/$goalId',
    data: {'title': title, 'targetDate': ApiDateCodec.encodeDate(targetDate)},
    decoder: _milestone,
  );
  Future<ApiResult<GoalMilestoneModel>> updateMilestone({
    required int id,
    required String title,
    required DateTime targetDate,
  }) => _api.put(
    '/api/goal-milestones/$id',
    data: {'title': title, 'targetDate': ApiDateCodec.encodeDate(targetDate)},
    decoder: _milestone,
  );
  Future<ApiResult<GoalMilestoneModel>> completeMilestone(int id) =>
      _api.patch('/api/goal-milestones/$id/complete', decoder: _milestone);
  Future<ApiResult<void>> deleteMilestone(int id) =>
      _api.delete('/api/goal-milestones/$id', decoder: (_) {});

  Future<ApiResult<List<GoalScheduleModel>>> getSchedules(int goalId) =>
      _api.get(
        '/api/goal-schedules/goal/$goalId',
        decoder: (data) => _list(data, GoalScheduleModel.fromJson),
      );
  Future<ApiResult<GoalScheduleModel>> createSchedule({
    required int goalId,
    required DateTime scheduleDate,
    required MoneyAmount amount,
  }) => _api.post(
    '/api/goal-schedules',
    data: _scheduleBody(goalId, scheduleDate, amount),
    decoder: _schedule,
  );
  Future<ApiResult<GoalScheduleModel>> updateSchedule({
    required int id,
    required int goalId,
    required DateTime scheduleDate,
    required MoneyAmount amount,
  }) => _api.put(
    '/api/goal-schedules/$id',
    data: _scheduleBody(goalId, scheduleDate, amount),
    decoder: _schedule,
  );
  Future<ApiResult<GoalScheduleModel>> completeSchedule(int id) =>
      _api.patch('/api/goal-schedules/$id/complete', decoder: _schedule);
  Future<ApiResult<void>> deleteSchedule(int id) =>
      _api.delete('/api/goal-schedules/$id', decoder: (_) {});

  static Map<String, dynamic> _goalBody(
    String title,
    String? description,
    MoneyAmount target,
    MoneyAmount current,
    DateTime deadline,
  ) => {
    'title': title.trim(),
    'description': description?.trim(),
    'targetAmount': target.toApiString(),
    'currentAmount': current.toApiString(),
    'deadline': ApiDateCodec.encodeDate(deadline),
  };
  static Map<String, dynamic> _scheduleBody(
    int goalId,
    DateTime date,
    MoneyAmount amount,
  ) => {
    'goalId': goalId,
    'scheduleDate': ApiDateCodec.encodeDate(date),
    'amount': amount.toApiString(),
  };
  static GoalModel _goal(Object? data) =>
      GoalModel.fromJson(Map<String, dynamic>.from(data! as Map));
  static GoalMilestoneModel _milestone(Object? data) =>
      GoalMilestoneModel.fromJson(Map<String, dynamic>.from(data! as Map));
  static GoalScheduleModel _schedule(Object? data) =>
      GoalScheduleModel.fromJson(Map<String, dynamic>.from(data! as Map));
  static List<T> _list<T>(
    Object? data,
    T Function(Map<String, dynamic>) decoder,
  ) => (data! as List)
      .map((item) => decoder(Map<String, dynamic>.from(item as Map)))
      .toList(growable: false);
}
