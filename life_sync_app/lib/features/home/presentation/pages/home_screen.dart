import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';
import 'package:life_sync_app/features/habits/presentation/controllers/habit_controller.dart';
import 'package:life_sync_app/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:life_sync_app/features/tasks/data/models/task_models.dart';
import 'package:life_sync_app/features/tasks/presentation/controllers/task_controller.dart';
import 'package:life_sync_app/features/user/presentation/controllers/profile_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProfileController _profileController;
  late final TaskController _taskController;
  late final HabitController _habitController;
  late final NotificationController _notificationController;

  static const _monthNames = <String>[
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

  static const _weekdayInitials = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ProfileController>();
    _taskController = Get.find<TaskController>();
    _habitController = Get.find<HabitController>();
    _notificationController = Get.find<NotificationController>();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 18) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final calendarStart = today.subtract(const Duration(days: 3));
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Profile & Date Selector
              RepaintBoundary(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final profile = _profileController.state.value.data;
                      final bytes = _profileController.imageBytes.value;
                      return GestureDetector(
                        onTap: () => Get.toNamed<void>(AppRoutes.profile),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: bytes == null
                                  ? null
                                  : MemoryImage(bytes),
                              child: bytes == null
                                  ? const Icon(Icons.person_outline_rounded)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _greeting,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  profile?.fullName ?? 'LifeSync user',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    Row(
                      children: [
                        Text(
                          '${_monthNames[today.month - 1]} ${today.year}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Obx(
                          () => InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () =>
                                Get.toNamed<void>(AppRoutes.notifications),
                            child: SizedBox.square(
                              dimension: 30,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  const Center(
                                    child: Icon(
                                      Icons.notifications_outlined,
                                      size: 22,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  if (_notificationController.unreadCount > 0)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          minWidth: 15,
                                          minHeight: 15,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          _notificationController.unreadCount >
                                                  9
                                              ? '9+'
                                              : _notificationController
                                                    .unreadCount
                                                    .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Calendar Strip Row
              RepaintBoundary(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    final date = calendarStart.add(Duration(days: index));
                    final selected =
                        date.year == today.year &&
                        date.month == today.month &&
                        date.day == today.day;
                    return _buildCalendarDay(
                      _weekdayInitials[date.weekday - 1],
                      date.day.toString(),
                      selected,
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Today's Progress Card
              RepaintBoundary(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Emoji / Illustration Placeholder
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('🤭', style: TextStyle(fontSize: 28)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Today's Progress",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Keep going! You're doing great.",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Stats Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Obx(() {
                            final tasks = _taskController.todayTasks;
                            final completed = tasks
                                .where((task) => task.isCompleted)
                                .length;
                            return Row(
                              children: [
                                const Icon(
                                  Icons.description_outlined,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$completed/${tasks.length} Tasks',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          }),
                          const SizedBox(height: 6),
                          Obx(
                            () => Row(
                              children: [
                                const Icon(
                                  Icons.autorenew,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_habitController.todayCompletedCount}/${_habitController.todayHabits.length} Habits',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Today's Tasks Section
              RepaintBoundary(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    final tasks = _taskController.todayTasks;
                    final remaining = tasks
                        .where((task) => !task.isCompleted)
                        .length;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Today's Tasks",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$remaining remaining',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: () =>
                                  Get.toNamed<void>(AppRoutes.taskEditor),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFF0F5FF),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(
                                Icons.add,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              label: const Text(
                                'Add Task',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (tasks.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              'No tasks due today.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else
                          for (final task in tasks.take(3))
                            _buildTaskItem(task),
                        const SizedBox(height: 8),
                        Center(
                          child: TextButton(
                            onPressed: () => Get.toNamed<void>(AppRoutes.tasks),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'View All Tasks',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.chevron_right,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Habits Section
              RepaintBoundary(
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Habits',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_habitController.todayCompletedCount}/${_habitController.todayHabits.length} Completed',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get.toNamed<void>(AppRoutes.habits),
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_habitController.todayHabits.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              'No habits scheduled today.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else
                          for (final habit in _habitController.todayHabits.take(
                            3,
                          )) ...[
                            _buildHabitRow(habit),
                            const SizedBox(height: 10),
                          ],
                        Center(
                          child: TextButton.icon(
                            onPressed: () =>
                                Get.toNamed<void>(AppRoutes.habitEditor),
                            icon: const Icon(Icons.add, size: 14),
                            label: const Text(
                              'Add Habit',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarDay(String dayLetter, String dateNum, bool isSelected) {
    return Column(
      children: [
        Text(
          dayLetter,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? AppColors.primary : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            dateNum,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => Get.toNamed<void>(AppRoutes.taskEditor, arguments: task),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  InkWell(
                    onTap: task.isCompleted
                        ? null
                        : () => _taskController.completeTask(task),
                    child: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.isCompleted
                          ? AppColors.primary
                          : Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      task.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.grey : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _taskPriorityLabel(task.priority),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _taskPriorityLabel(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => 'Low',
      TaskPriority.normal => 'Normal',
      TaskPriority.high => 'High',
      TaskPriority.urgent => 'Urgent',
    };
  }

  Widget _buildHabitRow(HabitModel habit) {
    final done = _habitController.isCompletedOn(habit.habitId, DateTime.now());
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () =>
                  Get.toNamed<void>(AppRoutes.habitProgress, arguments: habit),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1FC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.autorenew,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          habit.active
                              ? '🔥 ${habit.streak} day streak'
                              : 'Paused',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton.icon(
            onPressed:
                done || !habit.active || _habitController.isSubmitting.value
                ? null
                : () =>
                      _habitController.recordCompletion(habit, DateTime.now()),
            style: TextButton.styleFrom(
              backgroundColor: done
                  ? const Color(0xFFEBF3FF)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: done
                  ? BorderSide.none
                  : const BorderSide(color: AppColors.primary),
            ),
            icon: const Icon(Icons.check, size: 12),
            label: Text(
              done ? 'Done' : 'Complete',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
