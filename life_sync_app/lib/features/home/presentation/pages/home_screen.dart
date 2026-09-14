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

final class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends State<HomeScreen> {
  late final ProfileController _profile;
  late final TaskController _tasks;
  late final HabitController _habits;
  late final NotificationController _notifications;

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
  static const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    _profile = Get.find<ProfileController>();
    _tasks = Get.find<TaskController>();
    _habits = Get.find<HabitController>();
    _notifications = Get.find<NotificationController>();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 18) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  Future<void> _refresh() async {
    await Future.wait([
      _profile.loadProfile(refresh: true),
      _tasks.loadTasks(refresh: true),
      _habits.loadHabits(refresh: true),
      _notifications.load(refresh: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 118),
            children: [
              Row(
                children: [
                  Obx(() {
                    final profile = _profile.state.value.data;
                    final bytes = _profile.imageBytes.value;
                    return InkWell(
                      onTap: () => Get.toNamed<void>(AppRoutes.profile),
                      borderRadius: BorderRadius.circular(28),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 23,
                            backgroundColor: colors.elevatedSurface,
                            backgroundImage: bytes == null
                                ? null
                                : MemoryImage(bytes),
                            child: bytes == null
                                ? const Icon(Icons.person_outline_rounded)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _greeting,
                                style: TextStyle(
                                  color: colors.secondaryText,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                profile?.fullName ?? 'LifeSync user',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colors.primaryBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  const Spacer(),
                  Text(
                    '${_months[today.month - 1]} ${today.year}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Obx(
                    () => IconButton(
                      tooltip: 'Notifications',
                      onPressed: () =>
                          Get.toNamed<void>(AppRoutes.notifications),
                      icon: Badge(
                        isLabelVisible: _notifications.unreadCount > 0,
                        label: Text('${_notifications.unreadCount}'),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: colors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final date = monday.add(Duration(days: index));
                  final selected =
                      date.day == today.day &&
                      date.month == today.month &&
                      date.year == today.year;
                  return Column(
                    children: [
                      Text(
                        _weekdays[index],
                        style: TextStyle(
                          color: selected
                              ? colors.primaryBlue
                              : colors.secondaryText,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? colors.primaryBlue
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color: selected ? Colors.white : colors.primaryText,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.elevatedSurface,
                        border: Border.all(color: colors.border, width: 7),
                      ),
                      child: const Text('🤭', style: TextStyle(fontSize: 30)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today’s Progress',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Keep going! You’re doing great.',
                            style: TextStyle(
                              color: colors.secondaryText,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      final todayTasks = _tasks.todayTasks;
                      final completedTasks = todayTasks
                          .where((task) => task.isCompleted)
                          .length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProgressCount(
                            icon: Icons.task_alt_outlined,
                            value: '$completedTasks/${todayTasks.length}',
                            label: 'Tasks',
                          ),
                          const SizedBox(height: 8),
                          _ProgressCount(
                            icon: Icons.autorenew,
                            value:
                                '${_habits.todayCompletedCount}/${_habits.todayHabits.length}',
                            label: 'Habits',
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                child: Obx(() {
                  final tasks = _tasks.todayTasks;
                  final remaining = tasks
                      .where((task) => !task.isCompleted)
                      .length;
                  return Column(
                    children: [
                      _SectionHeader(
                        title: 'Today’s Tasks',
                        subtitle: '$remaining remaining',
                        action: TextButton.icon(
                          onPressed: () =>
                              Get.toNamed<void>(AppRoutes.taskEditor),
                          icon: const Icon(Icons.add, size: 17),
                          label: const Text('Add Task'),
                        ),
                      ),
                      if (tasks.isEmpty)
                        _EmptyRow(
                          icon: Icons.task_alt_outlined,
                          message: 'No tasks assigned for today.',
                        )
                      else
                        ...tasks.take(3).map(_taskRow),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => Get.toNamed<void>(AppRoutes.tasks),
                          child: const Text('View All'),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                child: Obx(() {
                  final habits = _habits.todayHabits;
                  return Column(
                    children: [
                      _SectionHeader(
                        title: 'Habits',
                        subtitle:
                            '${_habits.todayCompletedCount}/${habits.length} Completed',
                        action: TextButton(
                          onPressed: () => Get.toNamed<void>(AppRoutes.habits),
                          child: const Text('View All'),
                        ),
                      ),
                      if (habits.isEmpty)
                        _EmptyRow(
                          icon: Icons.autorenew,
                          message: 'No habits scheduled today.',
                        )
                      else
                        ...habits.take(3).map(_habitRow),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _taskRow(TaskModel task) {
    final colors = context.lifeSyncColors;
    return InkWell(
      onTap: () => Get.toNamed<void>(AppRoutes.taskEditor, arguments: task),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            InkWell(
              onTap: task.isCompleted ? null : () => _tasks.completeTask(task),
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  task.isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  size: 20,
                  color: task.isCompleted ? colors.primaryBlue : colors.border,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                task.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  color: task.isCompleted
                      ? colors.secondaryText
                      : colors.primaryText,
                  fontSize: 13,
                ),
              ),
            ),
            Text(
              task.priority.name.capitalizeFirst!,
              style: TextStyle(color: colors.primaryBlue, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _habitRow(HabitModel habit) {
    final colors = context.lifeSyncColors;
    final done = _habits.isCompletedOn(habit.habitId, DateTime.now());
    return InkWell(
      onTap: () => Get.toNamed<void>(AppRoutes.habitProgress, arguments: habit),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primaryBlue.withValues(alpha: .16),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.autorenew, color: colors.primaryBlue, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(habit.name, style: const TextStyle(fontSize: 13)),
                  Text(
                    habit.active ? '🔥 ${habit.streak} day streak' : 'Paused',
                    style: TextStyle(color: colors.secondaryText, fontSize: 10),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: done || !habit.active || _habits.isSubmitting.value
                  ? null
                  : () => _habits.recordCompletion(habit, DateTime.now()),
              icon: const Icon(Icons.check, size: 14),
              label: Text(done ? 'Done' : 'Complete'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.pageBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: child,
    );
  }
}

final class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.action,
  });
  final String title;
  final String subtitle;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: colors.secondaryText, fontSize: 10),
              ),
            ],
          ),
        ),
        action,
      ],
    );
  }
}

final class _ProgressCount extends StatelessWidget {
  const _ProgressCount({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Row(
      children: [
        Icon(icon, color: colors.primaryBlue, size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 11)),
            Text(
              label,
              style: TextStyle(color: colors.secondaryText, fontSize: 9),
            ),
          ],
        ),
      ],
    );
  }
}

final class _EmptyRow extends StatelessWidget {
  const _EmptyRow({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: colors.secondaryText),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: TextStyle(color: colors.secondaryText, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
