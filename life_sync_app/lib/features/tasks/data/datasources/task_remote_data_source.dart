import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/utils/api_date_codec.dart';
import 'package:life_sync_app/features/tasks/data/models/task_models.dart';

final class TaskRemoteDataSource {
  const TaskRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResult<List<TaskModel>>> getTasks() {
    return _apiClient.get<List<TaskModel>>(
      '/api/tasks',
      decoder: (data) => (data! as List)
          .map(
            (item) =>
                TaskModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false),
    );
  }

  Future<ApiResult<TaskModel>> createTask({
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskPriority priority,
    TaskStatus? status,
  }) {
    return _apiClient.post<TaskModel>(
      '/api/tasks',
      data: _taskRequest(
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        status: status,
      ),
      decoder: _decodeTask,
    );
  }

  Future<ApiResult<TaskModel>> updateTask({
    required int taskId,
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskPriority priority,
    required TaskStatus status,
  }) {
    return _apiClient.put<TaskModel>(
      '/api/tasks/$taskId',
      data: _taskRequest(
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        status: status,
      ),
      decoder: _decodeTask,
    );
  }

  Future<ApiResult<TaskModel>> completeTask(int taskId) {
    return _apiClient.patch<TaskModel>(
      '/api/tasks/$taskId/complete',
      decoder: _decodeTask,
    );
  }

  Future<ApiResult<void>> deleteTask(int taskId) {
    return _apiClient.delete<void>('/api/tasks/$taskId', decoder: (_) {});
  }

  Future<ApiResult<List<SubTaskModel>>> getSubTasks(int taskId) {
    return _apiClient.get<List<SubTaskModel>>(
      '/api/subtasks/task/$taskId',
      decoder: (data) => (data! as List)
          .map(
            (item) =>
                SubTaskModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false),
    );
  }

  Future<ApiResult<SubTaskModel>> createSubTask({
    required int taskId,
    required String title,
  }) {
    return _apiClient.post<SubTaskModel>(
      '/api/subtasks/$taskId',
      data: {'title': title},
      decoder: _decodeSubTask,
    );
  }

  Future<ApiResult<SubTaskModel>> updateSubTask({
    required int subTaskId,
    required String title,
  }) {
    return _apiClient.put<SubTaskModel>(
      '/api/subtasks/$subTaskId',
      data: {'title': title},
      decoder: _decodeSubTask,
    );
  }

  Future<ApiResult<SubTaskModel>> completeSubTask(int subTaskId) {
    return _apiClient.patch<SubTaskModel>(
      '/api/subtasks/$subTaskId/complete',
      decoder: _decodeSubTask,
    );
  }

  Future<ApiResult<void>> deleteSubTask(int subTaskId) {
    return _apiClient.delete<void>('/api/subtasks/$subTaskId', decoder: (_) {});
  }

  static Map<String, dynamic> _taskRequest({
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskPriority priority,
    required TaskStatus? status,
  }) {
    return {
      'title': title,
      'description': description,
      'dueDate': ApiDateCodec.encodeDate(dueDate),
      'priority': priority.apiValue,
      if (status != null) 'status': status.apiValue,
    };
  }

  static TaskModel _decodeTask(Object? data) {
    return TaskModel.fromJson(Map<String, dynamic>.from(data! as Map));
  }

  static SubTaskModel _decodeSubTask(Object? data) {
    return SubTaskModel.fromJson(Map<String, dynamic>.from(data! as Map));
  }
}
