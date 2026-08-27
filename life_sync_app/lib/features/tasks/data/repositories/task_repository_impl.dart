import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:life_sync_app/features/tasks/data/models/task_models.dart';
import 'package:life_sync_app/features/tasks/domain/repositories/task_repository.dart';

final class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl(this._remote);
  final TaskRemoteDataSource _remote;

  @override
  Future<ApiResult<List<TaskModel>>> getTasks() => _remote.getTasks();

  @override
  Future<ApiResult<TaskModel>> createTask({
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskPriority priority,
    TaskStatus? status,
  }) => _remote.createTask(
    title: title,
    description: description,
    dueDate: dueDate,
    priority: priority,
    status: status,
  );

  @override
  Future<ApiResult<TaskModel>> updateTask({
    required int taskId,
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskPriority priority,
    required TaskStatus status,
  }) => _remote.updateTask(
    taskId: taskId,
    title: title,
    description: description,
    dueDate: dueDate,
    priority: priority,
    status: status,
  );

  @override
  Future<ApiResult<TaskModel>> completeTask(int taskId) =>
      _remote.completeTask(taskId);

  @override
  Future<ApiResult<void>> deleteTask(int taskId) => _remote.deleteTask(taskId);

  @override
  Future<ApiResult<List<SubTaskModel>>> getSubTasks(int taskId) =>
      _remote.getSubTasks(taskId);

  @override
  Future<ApiResult<SubTaskModel>> createSubTask({
    required int taskId,
    required String title,
  }) => _remote.createSubTask(taskId: taskId, title: title);

  @override
  Future<ApiResult<SubTaskModel>> updateSubTask({
    required int subTaskId,
    required String title,
  }) => _remote.updateSubTask(subTaskId: subTaskId, title: title);

  @override
  Future<ApiResult<SubTaskModel>> completeSubTask(int subTaskId) =>
      _remote.completeSubTask(subTaskId);

  @override
  Future<ApiResult<void>> deleteSubTask(int subTaskId) =>
      _remote.deleteSubTask(subTaskId);
}
