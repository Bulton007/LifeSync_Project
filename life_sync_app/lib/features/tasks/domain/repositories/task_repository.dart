import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/tasks/data/models/task_models.dart';

abstract interface class TaskRepository {
  Future<ApiResult<List<TaskModel>>> getTasks();

  Future<ApiResult<TaskModel>> createTask({
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskPriority priority,
    TaskStatus? status,
  });

  Future<ApiResult<TaskModel>> updateTask({
    required int taskId,
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskPriority priority,
    required TaskStatus status,
  });

  Future<ApiResult<TaskModel>> completeTask(int taskId);
  Future<ApiResult<void>> deleteTask(int taskId);
  Future<ApiResult<List<SubTaskModel>>> getSubTasks(int taskId);
  Future<ApiResult<SubTaskModel>> createSubTask({
    required int taskId,
    required String title,
  });
  Future<ApiResult<SubTaskModel>> updateSubTask({
    required int subTaskId,
    required String title,
  });
  Future<ApiResult<SubTaskModel>> completeSubTask(int subTaskId);
  Future<ApiResult<void>> deleteSubTask(int subTaskId);
}
