import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/widgets/app_empty_view.dart';
import 'package:life_sync_app/core/widgets/app_error_view.dart';
import 'package:life_sync_app/core/widgets/app_loading_view.dart';
import 'package:life_sync_app/features/tasks/data/models/task_models.dart';
import 'package:life_sync_app/features/tasks/presentation/controllers/task_controller.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<ToDoListScreen> {
  late final TaskController _controller;

  static const _months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const _weekdays = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    _controller = Get.find<TaskController>();
  }

  Future<void> _showAddTodoPopup(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descController = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.open_in_full, size: 16, color: Colors.grey),
                ),
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'What do you need to get done today?',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    final title = value?.trim() ?? '';
                    if (title.isEmpty) return 'Task title is required.';
                    if (title.length > 200) return 'Maximum 200 characters.';
                    return null;
                  },
                ),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    border: InputBorder.none,
                  ),
                  validator: (value) => (value?.length ?? 0) > 1000
                      ? 'Maximum 1000 characters.'
                      : null,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildChip(
                      Icons.calendar_today_outlined,
                      _dateLabel(_controller.selectedDate.value),
                      AppColors.primary,
                    ),
                    _buildChip(
                      Icons.flag_outlined,
                      'Normal',
                      Colors.grey.shade700,
                    ),
                  ],
                ),
                Obx(() {
                  final message = _controller.errorMessage.value;
                  if (message == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _controller.isSubmitting.value
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;
                              final created = await _controller.createTask(
                                title: titleController.text,
                                description: descController.text,
                                dueDate: _controller.selectedDate.value,
                                priority: TaskPriority.normal,
                              );
                              if (created && context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _controller.isSubmitting.value
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save Task',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    titleController.dispose();
    descController.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null) _controller.selectDate(selected);
  }

  Future<void> _showTaskDetails(TaskModel task) async {
    await _controller.loadSubTasks(task.id);
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit task',
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      Get.toNamed<void>(AppRoutes.taskEditor, arguments: task);
                    },
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: 'Delete task',
                    onPressed: () async {
                      final deleted = await _controller.deleteTask(task.id);
                      if (deleted && sheetContext.mounted) {
                        Navigator.pop(sheetContext);
                      }
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              ),
              if (task.description?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(task.description!),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtasks',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => _addSubTask(sheetContext, task.id),
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ],
              ),
              Obx(() {
                final items = _controller.subTasks[task.id] ?? const [];
                if (items.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No subtasks yet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final subTask = items[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Checkbox(
                          value: subTask.completed,
                          onChanged: subTask.completed
                              ? null
                              : (_) => _controller.completeSubTask(subTask),
                        ),
                        title: Text(
                          subTask.title,
                          style: TextStyle(
                            decoration: subTask.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (action) {
                            if (action == 'edit') {
                              _editSubTask(sheetContext, subTask);
                            } else {
                              _controller.deleteSubTask(subTask);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addSubTask(BuildContext context, int taskId) async {
    final title = await _subTaskDialog(context, title: 'Add subtask');
    if (title != null) await _controller.createSubTask(taskId, title);
  }

  Future<void> _editSubTask(BuildContext context, SubTaskModel subTask) async {
    final title = await _subTaskDialog(
      context,
      title: 'Edit subtask',
      initialValue: subTask.title,
    );
    if (title != null) await _controller.updateSubTask(subTask, title);
  }

  Future<String?> _subTaskDialog(
    BuildContext context, {
    required String title,
    String? initialValue,
  }) async {
    final textController = TextEditingController(text: initialValue);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: textController,
          autofocus: true,
          maxLength: 200,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = textController.text.trim();
              if (text.isNotEmpty) Navigator.pop(context, text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    textController.dispose();
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _controller.loadTasks(refresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RepaintBoundary(child: _buildHeader()),
                const SizedBox(height: 24),
                RepaintBoundary(child: _buildCalendarStrip()),
                const SizedBox(height: 28),
                const Text(
                  'Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  final state = _controller.state.value;
                  if (state.data == null && state.isBusy) {
                    return const SizedBox(
                      height: 240,
                      child: AppLoadingView(message: 'Loading tasks…'),
                    );
                  }
                  if (state.data == null && state.exception != null) {
                    return AppErrorView(
                      message: state.exception!.message,
                      onRetry: _controller.loadTasks,
                    );
                  }
                  final tasks = _controller.selectedDateTasks;
                  if (tasks.isEmpty) {
                    return AppEmptyView(
                      title: 'No tasks for this day',
                      message: 'Add a task to start planning your day.',
                      icon: Icons.task_alt_rounded,
                      actionLabel: 'Add task',
                      onAction: () => _showAddTodoPopup(context),
                    );
                  }
                  return RepaintBoundary(
                    child: Column(
                      children: [
                        for (int index = 0; index < tasks.length; index++)
                          _buildTimelineItem(
                            task: tasks[index],
                            isLast: index == tasks.length - 1,
                          ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoPopup(context),
        backgroundColor: const Color(0xFF2979FF),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      final date = _controller.selectedDate.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Column(
            children: [
              Text(
                date.year.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _months[date.month - 1],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              onPressed: _pickDate,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCalendarStrip() {
    return Obx(() {
      final selected = _controller.selectedDate.value;
      final start = selected.subtract(const Duration(days: 3));
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final date = start.add(Duration(days: index));
          final isSelected = _sameDate(date, selected);
          return InkWell(
            onTap: () => _controller.selectDate(date),
            borderRadius: BorderRadius.circular(20),
            child: _buildCalendarDay(
              _weekdays[date.weekday - 1],
              date.day.toString(),
              isSelected,
            ),
          );
        }),
      );
    });
  }

  Widget _buildChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(String dayLetter, String dateNum, bool isSelected) {
    return Column(
      children: [
        Text(
          dayLetter,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? AppColors.primary : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            dateNum,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({required TaskModel task, required bool isLast}) {
    return InkWell(
      onTap: () => _showTaskDetails(task),
      child: Stack(
        children: [
          if (!isLast)
            Positioned(
              left: 75,
              top: 22,
              bottom: 0,
              child: Container(width: 2, color: Colors.grey.shade300),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 65,
                child: Text(
                  _priorityLabel(task.priority),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              InkWell(
                onTap: task.isCompleted
                    ? null
                    : () => _controller.completeTask(task),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted
                          ? AppColors.primary
                          : Colors.grey.shade400,
                      width: 1.5,
                    ),
                    color: task.isCompleted ? AppColors.primary : Colors.white,
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (task.description?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _priorityLabel(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => 'Low',
      TaskPriority.normal => 'Normal',
      TaskPriority.high => 'High',
      TaskPriority.urgent => 'Urgent',
    };
  }

  static String _dateLabel(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  static bool _sameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
