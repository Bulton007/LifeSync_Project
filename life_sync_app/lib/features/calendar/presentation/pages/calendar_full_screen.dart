import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/core/widgets/app_error_view.dart';
import 'package:life_sync_app/core/widgets/app_loading_view.dart';
import 'package:life_sync_app/features/tasks/data/models/task_models.dart';
import 'package:life_sync_app/features/tasks/presentation/controllers/task_controller.dart';

final class CalendarFullScreen extends StatefulWidget {
  const CalendarFullScreen({super.key});

  @override
  State<CalendarFullScreen> createState() => _CalendarFullScreenState();
}

final class _CalendarFullScreenState extends State<CalendarFullScreen> {
  late final TaskController _taskController;
  late DateTime _displayedMonth;

  static const _months = [
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

  @override
  void initState() {
    super.initState();
    _taskController = Get.find<TaskController>();
    final selected = _taskController.selectedDate.value;
    _displayedMonth = DateTime(selected.year, selected.month);
  }

  void _changeMonth(int offset) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + offset,
      );
    });
    _taskController.selectDate(_displayedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Obx(() {
          final state = _taskController.state.value;
          if (state.status == ViewStatus.initial ||
              state.status == ViewStatus.loading) {
            return const AppLoadingView(message: 'Loading calendar…');
          }
          if (state.status == ViewStatus.error && state.data == null) {
            return AppErrorView(
              message: state.exception?.message ?? 'Calendar could not load.',
              onRetry: _taskController.loadTasks,
            );
          }
          return RefreshIndicator(
            onRefresh: () => _taskController.loadTasks(refresh: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
              children: [
                if (state.status == ViewStatus.error && state.exception != null)
                  _InlineError(message: state.exception!.message),
                _CalendarHeader(
                  title:
                      '${_months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                  onPrevious: () => _changeMonth(-1),
                  onNext: () => _changeMonth(1),
                ),
                const SizedBox(height: 20),
                RepaintBoundary(
                  child: _MonthGrid(
                    month: _displayedMonth,
                    tasks: _taskController.tasks,
                    selectedDate: _taskController.selectedDate.value,
                    onSelected: _taskController.selectDate,
                  ),
                ),
                const SizedBox(height: 24),
                _TaskHeader(
                  date: _taskController.selectedDate.value,
                  onOpenAll: () => Get.toNamed<void>(AppRoutes.tasks),
                  onAdd: () => Get.toNamed<void>(
                    AppRoutes.taskEditor,
                    arguments: _taskController.selectedDate.value,
                  ),
                ),
                const SizedBox(height: 12),
                if (_taskController.selectedDateTasks.isEmpty)
                  const _CalendarEmpty(
                    message: 'No tasks are due on this date.',
                  )
                else
                  ..._taskController.selectedDateTasks.map(
                    (task) => _TaskTimelineItem(
                      task: task,
                      controller: _taskController,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

final class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.title,
    required this.onPrevious,
    required this.onNext,
  });

  final String title;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.chevron_left, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      const Spacer(),
      Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      const SizedBox(width: 8),
      IconButton(
        tooltip: 'Previous month',
        icon: const Icon(Icons.chevron_left, color: AppColors.primary),
        onPressed: onPrevious,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
      const SizedBox(width: 4),
      IconButton(
        tooltip: 'Next month',
        icon: const Icon(Icons.chevron_right, color: AppColors.primary),
        onPressed: onNext,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    ],
  );
}

final class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.tasks,
    required this.selectedDate,
    required this.onSelected,
  });

  final DateTime month;
  final List<TaskModel> tasks;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month);
    final leadingDays = first.weekday % DateTime.daysPerWeek;
    final gridStart = first.subtract(Duration(days: leadingDays));
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F1FC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final day in [
                  'Sun',
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                ])
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                for (var week = 0; week < 6; week++) ...[
                  if (week > 0) const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (var weekday = 0; weekday < 7; weekday++)
                        _DayCell(
                          date: gridStart.add(
                            Duration(days: week * 7 + weekday),
                          ),
                          displayedMonth: month,
                          selectedDate: selectedDate,
                          taskCount: tasks
                              .where(
                                (task) => _sameDate(
                                  task.dueDate,
                                  gridStart.add(
                                    Duration(days: week * 7 + weekday),
                                  ),
                                ),
                              )
                              .length,
                          onSelected: onSelected,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.displayedMonth,
    required this.selectedDate,
    required this.taskCount,
    required this.onSelected,
  });

  final DateTime date;
  final DateTime displayedMonth;
  final DateTime selectedDate;
  final int taskCount;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = _sameDate(date, selectedDate);
    final inMonth = date.month == displayedMonth.month;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => onSelected(date),
      child: SizedBox.square(
        dimension: 38,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : null,
                shape: BoxShape.circle,
              ),
              child: Text(
                date.day.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected
                      ? Colors.white
                      : inMonth
                      ? Colors.black87
                      : Colors.grey.shade400,
                ),
              ),
            ),
            if (taskCount > 0)
              Positioned(
                bottom: 0,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : const Color(0xFF00ACC1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _TaskHeader extends StatelessWidget {
  const _TaskHeader({
    required this.date,
    required this.onOpenAll,
    required this.onAdd,
  });

  final DateTime date;
  final VoidCallback onOpenAll;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To-dos List',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(_date(date), style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      IconButton(
        tooltip: 'Add task',
        onPressed: onAdd,
        icon: const Icon(Icons.add_circle_outline),
        color: AppColors.primary,
      ),
      IconButton(
        tooltip: 'Open all tasks',
        onPressed: onOpenAll,
        icon: const Icon(Icons.open_in_full, size: 18),
      ),
    ],
  );
}

final class _TaskTimelineItem extends StatelessWidget {
  const _TaskTimelineItem({required this.task, required this.controller});

  final TaskModel task;
  final TaskController controller;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: task.isCompleted || controller.isSubmitting.value
            ? null
            : (_) async {
                final saved = await controller.completeTask(task);
                if (!saved && context.mounted) {
                  _showError(context, controller);
                }
              },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        [
          _priority(task.priority),
          _status(task.status),
          if (task.description?.isNotEmpty == true) task.description!,
        ].join(' • '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            Get.toNamed<void>(AppRoutes.taskEditor, arguments: task);
          } else {
            _deleteTask(context, controller, task);
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    ),
  );
}

final class _CalendarEmpty extends StatelessWidget {
  const _CalendarEmpty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      children: [
        Icon(Icons.event_available_outlined, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(message, style: const TextStyle(color: Colors.grey)),
      ],
    ),
  );
}

final class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.red.shade50,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(message, style: TextStyle(color: Colors.red.shade800)),
  );
}

Future<void> _deleteTask(
  BuildContext context,
  TaskController controller,
  TaskModel task,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete task?'),
      content: Text('Delete “${task.title}” and its subtasks?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  final saved = await controller.deleteTask(task.id);
  if (!saved && context.mounted) _showError(context, controller);
}

void _showError(BuildContext context, TaskController controller) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(controller.errorMessage.value ?? 'Task could not update.'),
    ),
  );
}

bool _sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

String _date(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/'
    '${value.month.toString().padLeft(2, '0')}/${value.year}';

String _priority(TaskPriority value) => switch (value) {
  TaskPriority.low => 'Low priority',
  TaskPriority.normal => 'Normal priority',
  TaskPriority.high => 'High priority',
  TaskPriority.urgent => 'Urgent',
};

String _status(TaskStatus value) => switch (value) {
  TaskStatus.pending => 'Pending',
  TaskStatus.inProgress => 'In progress',
  TaskStatus.completed => 'Completed',
};
