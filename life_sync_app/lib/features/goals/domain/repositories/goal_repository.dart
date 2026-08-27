import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';
import 'package:life_sync_app/features/goals/data/models/goal_models.dart';

abstract interface class GoalRepository {
  Future<ApiResult<List<GoalModel>>> getGoals();
  Future<ApiResult<GoalModel>> createGoal({
    required String title,
    String? description,
    required MoneyAmount targetAmount,
    required MoneyAmount currentAmount,
    required DateTime deadline,
  });
  Future<ApiResult<GoalModel>> updateGoal({
    required int id,
    required String title,
    String? description,
    required MoneyAmount targetAmount,
    required MoneyAmount currentAmount,
    required DateTime deadline,
  });
  Future<ApiResult<void>> deleteGoal(int id);
  Future<ApiResult<GoalModel>> completeGoal(int id);
  Future<ApiResult<GoalModel>> archiveGoal(int id);
  Future<ApiResult<List<GoalMilestoneModel>>> getMilestones(int goalId);
  Future<ApiResult<GoalMilestoneModel>> createMilestone({
    required int goalId,
    required String title,
    required DateTime targetDate,
  });
  Future<ApiResult<GoalMilestoneModel>> updateMilestone({
    required int id,
    required String title,
    required DateTime targetDate,
  });
  Future<ApiResult<GoalMilestoneModel>> completeMilestone(int id);
  Future<ApiResult<void>> deleteMilestone(int id);
  Future<ApiResult<List<GoalScheduleModel>>> getSchedules(int goalId);
  Future<ApiResult<GoalScheduleModel>> createSchedule({
    required int goalId,
    required DateTime scheduleDate,
    required MoneyAmount amount,
  });
  Future<ApiResult<GoalScheduleModel>> updateSchedule({
    required int id,
    required int goalId,
    required DateTime scheduleDate,
    required MoneyAmount amount,
  });
  Future<ApiResult<GoalScheduleModel>> completeSchedule(int id);
  Future<ApiResult<void>> deleteSchedule(int id);
}
