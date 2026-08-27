import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/goals/data/datasources/goal_remote_data_source.dart';
import 'package:life_sync_app/features/goals/data/models/goal_models.dart';
import 'package:life_sync_app/features/goals/domain/repositories/goal_repository.dart';

final class GoalRepositoryImpl implements GoalRepository {
  const GoalRepositoryImpl(this._remote);
  final GoalRemoteDataSource _remote;
  @override
  Future<ApiResult<List<GoalModel>>> getGoals() => _remote.getGoals();
  @override
  Future<ApiResult<GoalModel>> createGoal({
    required String title,
    String? description,
    required MoneyAmount targetAmount,
    required MoneyAmount currentAmount,
    required DateTime deadline,
  }) => _remote.createGoal(
    title: title,
    description: description,
    targetAmount: targetAmount,
    currentAmount: currentAmount,
    deadline: deadline,
  );
  @override
  Future<ApiResult<GoalModel>> updateGoal({
    required int id,
    required String title,
    String? description,
    required MoneyAmount targetAmount,
    required MoneyAmount currentAmount,
    required DateTime deadline,
  }) => _remote.updateGoal(
    id: id,
    title: title,
    description: description,
    targetAmount: targetAmount,
    currentAmount: currentAmount,
    deadline: deadline,
  );
  @override
  Future<ApiResult<void>> deleteGoal(int id) => _remote.deleteGoal(id);
  @override
  Future<ApiResult<GoalModel>> completeGoal(int id) => _remote.completeGoal(id);
  @override
  Future<ApiResult<GoalModel>> archiveGoal(int id) => _remote.archiveGoal(id);
  @override
  Future<ApiResult<List<GoalMilestoneModel>>> getMilestones(int goalId) =>
      _remote.getMilestones(goalId);
  @override
  Future<ApiResult<GoalMilestoneModel>> createMilestone({
    required int goalId,
    required String title,
    required DateTime targetDate,
  }) => _remote.createMilestone(
    goalId: goalId,
    title: title,
    targetDate: targetDate,
  );
  @override
  Future<ApiResult<GoalMilestoneModel>> updateMilestone({
    required int id,
    required String title,
    required DateTime targetDate,
  }) => _remote.updateMilestone(id: id, title: title, targetDate: targetDate);
  @override
  Future<ApiResult<GoalMilestoneModel>> completeMilestone(int id) =>
      _remote.completeMilestone(id);
  @override
  Future<ApiResult<void>> deleteMilestone(int id) =>
      _remote.deleteMilestone(id);
  @override
  Future<ApiResult<List<GoalScheduleModel>>> getSchedules(int goalId) =>
      _remote.getSchedules(goalId);
  @override
  Future<ApiResult<GoalScheduleModel>> createSchedule({
    required int goalId,
    required DateTime scheduleDate,
    required MoneyAmount amount,
  }) => _remote.createSchedule(
    goalId: goalId,
    scheduleDate: scheduleDate,
    amount: amount,
  );
  @override
  Future<ApiResult<GoalScheduleModel>> updateSchedule({
    required int id,
    required int goalId,
    required DateTime scheduleDate,
    required MoneyAmount amount,
  }) => _remote.updateSchedule(
    id: id,
    goalId: goalId,
    scheduleDate: scheduleDate,
    amount: amount,
  );
  @override
  Future<ApiResult<GoalScheduleModel>> completeSchedule(int id) =>
      _remote.completeSchedule(id);
  @override
  Future<ApiResult<void>> deleteSchedule(int id) => _remote.deleteSchedule(id);
}
