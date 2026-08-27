import 'package:life_sync_app/core/utils/api_date_codec.dart';

enum TaskPriority {
  low('LOW'),
  normal('NORMAL'),
  high('HIGH'),
  urgent('URGENT');

  const TaskPriority(this.apiValue);
  final String apiValue;

  static TaskPriority fromApi(String value) {
    return values.firstWhere((priority) => priority.apiValue == value);
  }
}

enum TaskStatus {
  pending('PENDING'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED');

  const TaskStatus(this.apiValue);
  final String apiValue;

  static TaskStatus fromApi(String value) {
    return values.firstWhere((status) => status.apiValue == value);
  }
}

final class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
    required this.dueDate,
    this.description,
    this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      priority: TaskPriority.fromApi(json['priority'] as String),
      status: TaskStatus.fromApi(json['status'] as String),
      dueDate: ApiDateCodec.decodeDate(json['dueDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : ApiDateCodec.decodeLocalDateTime(json['createdAt'] as String),
    );
  }

  final int id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime dueDate;
  final DateTime? createdAt;

  bool get isCompleted => status == TaskStatus.completed;
}

final class SubTaskModel {
  const SubTaskModel({
    required this.id,
    required this.title,
    required this.completed,
    required this.taskId,
  });

  factory SubTaskModel.fromJson(Map<String, dynamic> json) {
    return SubTaskModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      completed: json['completed'] as bool,
      taskId: (json['taskId'] as num).toInt(),
    );
  }

  final int id;
  final String title;
  final bool completed;
  final int taskId;
}
