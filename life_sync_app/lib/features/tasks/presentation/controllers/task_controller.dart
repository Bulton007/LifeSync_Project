import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/features/tasks/data/models/task_models.dart';
import 'package:life_sync_app/features/tasks/domain/repositories/task_repository.dart';

final class TaskController extends GetxController {
  TaskController(this._repository);

  final TaskRepository _repository;

  final state = const AsyncViewState<List<TaskModel>>.initial().obs;
  final selectedDate = DateTime.now().obs;
  final subTasks = <int, List<SubTaskModel>>{}.obs;
  final isSubmitting = false.obs;
  final errorMessage = RxnString();

  List<TaskModel> get tasks => state.value.data ?? const [];

  List<TaskModel> get selectedDateTasks => tasks
      .where((task) => _sameDate(task.dueDate, selectedDate.value))
      .toList(growable: false);

  List<TaskModel> get todayTasks {
    final today = DateTime.now();
    return tasks.where((task) => _sameDate(task.dueDate, today)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks({bool refresh = false}) async {
    final previous = state.value.data;
    state.value = refresh && previous != null
        ? AsyncViewState<List<TaskModel>>.refreshing(previous)
        : const AsyncViewState<List<TaskModel>>.loading();

    final result = await _repository.getTasks();
    result.when(
      success: (items) {
        state.value = items.isEmpty
            ? const AsyncViewState<List<TaskModel>>.empty()
            : AsyncViewState<List<TaskModel>>.success(items);
      },
      failure: (exception) {
        state.value = AsyncViewState<List<TaskModel>>.error(
          exception,
          previousData: previous,
        );
      },
    );
  }

  void selectDate(DateTime date) {
    selectedDate.value = DateTime(date.year, date.month, date.day);
  }

  Future<bool> createTask({
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskPriority priority,
  }) => _mutateTask(
    () => _repository.createTask(
      title: title.trim(),
      description: _emptyToNull(description),
      dueDate: dueDate,
      priority: priority,
    ),
    (created) => [...tasks, created],
  );

  Future<bool> updateTask({
    required TaskModel task,
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskPriority priority,
    required TaskStatus status,
  }) => _mutateTask(
    () => _repository.updateTask(
      taskId: task.id,
      title: title.trim(),
      description: _emptyToNull(description),
      dueDate: dueDate,
      priority: priority,
      status: status,
    ),
    (updated) => [
      for (final item in tasks)
        if (item.id == updated.id) updated else item,
    ],
  );

  Future<bool> completeTask(TaskModel task) {
    if (task.isCompleted) return Future.value(true);
    return _mutateTask(
      () => _repository.completeTask(task.id),
      (updated) => [
        for (final item in tasks)
          if (item.id == updated.id) updated else item,
      ],
    );
  }

  Future<bool> deleteTask(int taskId) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.deleteTask(taskId);
      final bool success = result.when<bool>(
        success: (_) {
          subTasks.remove(taskId);
          _setTasks(tasks.where((task) => task.id != taskId).toList());
          return true;
        },
        failure: _recordFailure,
      );
      return success;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> loadSubTasks(int taskId) async {
    final result = await _repository.getSubTasks(taskId);
    result.when(
      success: (items) => subTasks[taskId] = items,
      failure: (exception) => errorMessage.value = exception.message,
    );
  }

  Future<bool> createSubTask(int taskId, String title) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.createSubTask(
        taskId: taskId,
        title: title.trim(),
      );
      final bool success = result.when<bool>(
        success: (created) {
          subTasks[taskId] = [...?subTasks[taskId], created];
          return true;
        },
        failure: _recordFailure,
      );
      return success;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateSubTask(SubTaskModel subTask, String title) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.updateSubTask(
        subTaskId: subTask.id,
        title: title.trim(),
      );
      final bool success = result.when<bool>(
        success: (updated) {
          _replaceSubTask(updated);
          return true;
        },
        failure: _recordFailure,
      );
      return success;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> completeSubTask(SubTaskModel subTask) async {
    if (subTask.completed) return true;
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.completeSubTask(subTask.id);
      final bool success = result.when<bool>(
        success: (updated) {
          _replaceSubTask(updated);
          return true;
        },
        failure: _recordFailure,
      );
      return success;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteSubTask(SubTaskModel subTask) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.deleteSubTask(subTask.id);
      final bool success = result.when<bool>(
        success: (_) {
          subTasks[subTask.taskId] = [
            for (final item
                in subTasks[subTask.taskId] ?? const <SubTaskModel>[])
              if (item.id != subTask.id) item,
          ];
          return true;
        },
        failure: _recordFailure,
      );
      return success;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> _mutateTask(
    Future<ApiResult<TaskModel>> Function() operation,
    List<TaskModel> Function(TaskModel result) update,
  ) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final result = await operation();
      final bool success = result.when<bool>(
        success: (task) {
          _setTasks(update(task));
          return true;
        },
        failure: _recordFailure,
      );
      return success;
    } finally {
      isSubmitting.value = false;
    }
  }

  void _setTasks(List<TaskModel> items) {
    items.sort((a, b) {
      final dateOrder = a.dueDate.compareTo(b.dueDate);
      if (dateOrder != 0) return dateOrder;
      return (a.createdAt ?? a.dueDate).compareTo(b.createdAt ?? b.dueDate);
    });
    state.value = items.isEmpty
        ? const AsyncViewState<List<TaskModel>>.empty()
        : AsyncViewState<List<TaskModel>>.success(items);
  }

  void _replaceSubTask(SubTaskModel updated) {
    subTasks[updated.taskId] = [
      for (final item in subTasks[updated.taskId] ?? const <SubTaskModel>[])
        if (item.id == updated.id) updated else item,
    ];
  }

  bool _recordFailure(ApiException exception) {
    errorMessage.value = exception.message;
    return false;
  }

  static String? _emptyToNull(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  static bool _sameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
