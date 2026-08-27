import 'package:life_sync_app/core/utils/api_date_codec.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';

final class GoalModel {
  const GoalModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.completed,
    required this.archived,
    required this.deadline,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) => GoalModel(
    id: (json['id'] as num).toInt(),
    userId: (json['userId'] as num).toInt(),
    title: json['title'] as String,
    description: json['description'] as String?,
    targetAmount: MoneyAmount.parse(json['targetAmount']),
    currentAmount: MoneyAmount.parse(json['currentAmount']),
    completed: json['completed'] as bool? ?? false,
    archived: json['archived'] as bool? ?? false,
    deadline: ApiDateCodec.decodeDate(json['deadline'] as String),
    createdAt: json['createdAt'] == null
        ? null
        : ApiDateCodec.decodeLocalDateTime(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : ApiDateCodec.decodeLocalDateTime(json['updatedAt'] as String),
  );

  final int id;
  final int userId;
  final String title;
  final String? description;
  final MoneyAmount targetAmount;
  final MoneyAmount currentAmount;
  final bool completed;
  final bool archived;
  final DateTime deadline;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  double get progress => completed ? 1 : currentAmount.ratioOf(targetAmount);
}

final class GoalMilestoneModel {
  const GoalMilestoneModel({
    required this.id,
    required this.title,
    required this.completed,
    required this.targetDate,
    required this.goalId,
  });
  factory GoalMilestoneModel.fromJson(Map<String, dynamic> json) =>
      GoalMilestoneModel(
        id: (json['id'] as num).toInt(),
        title: json['title'] as String,
        completed: json['completed'] as bool? ?? false,
        targetDate: ApiDateCodec.decodeDate(json['targetDate'] as String),
        goalId: (json['goalId'] as num).toInt(),
      );
  final int id;
  final String title;
  final bool completed;
  final DateTime targetDate;
  final int goalId;
}

final class GoalScheduleModel {
  const GoalScheduleModel({
    required this.goalScheduleId,
    required this.goalId,
    required this.scheduleDate,
    required this.amount,
    required this.completed,
    this.createdAt,
    this.updatedAt,
  });
  factory GoalScheduleModel.fromJson(Map<String, dynamic> json) =>
      GoalScheduleModel(
        goalScheduleId: (json['goalScheduleId'] as num).toInt(),
        goalId: (json['goalId'] as num).toInt(),
        scheduleDate: ApiDateCodec.decodeDate(json['scheduleDate'] as String),
        amount: MoneyAmount.parse(json['amount']),
        completed: json['completed'] as bool? ?? false,
        createdAt: json['createdAt'] == null
            ? null
            : ApiDateCodec.decodeLocalDateTime(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : ApiDateCodec.decodeLocalDateTime(json['updatedAt'] as String),
      );
  final int goalScheduleId;
  final int goalId;
  final DateTime scheduleDate;
  final MoneyAmount amount;
  final bool completed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
