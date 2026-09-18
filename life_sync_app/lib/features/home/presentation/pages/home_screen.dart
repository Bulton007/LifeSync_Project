import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/app_icons.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';
import 'package:life_sync_app/features/habits/presentation/controllers/habit_controller.dart';
import 'package:life_sync_app/features/habits/presentation/models/habit_item_model.dart';
import 'package:life_sync_app/features/habits/presentation/widgets/habits_card.dart';
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
  final Set<String> _expandedHabitIds = {'1'};
  final Map<String, bool> _subItemCompleted = {};

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

  void _toggleSubItem(Habit habit, HabitSubItem subItem) {
    setState(() {
      _subItemCompleted[subItem.id] = !subItem.isCompleted;
    });
  }

  void _toggleExpand(Habit habit) {
    setState(() {
      if (_expandedHabitIds.contains(habit.id)) {
        _expandedHabitIds.remove(habit.id);
      } else {
        _expandedHabitIds.add(habit.id);
      }
    });
  }

  List<Habit> _mapTodayHabits(List<HabitModel> models) {
    return List.generate(models.length, (index) {
      final model = models[index];
      final isCompleted = _habits.isCompletedOn(model.habitId, DateTime.now());

      final lines = (model.description ?? '')
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (index == 0) {
        final subHabits = lines.isNotEmpty
            ? [
                for (var i = 0; i < lines.length; i++)
                  HabitSubItem(
                    id: '${model.habitId}-$i',
                    title: lines[i],
                    isCompleted:
                        _subItemCompleted['${model.habitId}-$i'] ??
                        (i == lines.length - 1 && isCompleted),
                  ),
              ]
            : [
                HabitSubItem(
                  id: '${model.habitId}-1',
                  title: 'Make Breakfast',
                  isCompleted: _subItemCompleted['${model.habitId}-1'] ?? false,
                ),
                HabitSubItem(
                  id: '${model.habitId}-2',
                  title: 'Drink a Cup of Water',
                  isCompleted: _subItemCompleted['${model.habitId}-2'] ?? false,
                ),
                HabitSubItem(
                  id: '${model.habitId}-3',
                  title: 'Make bed',
                  isCompleted: _subItemCompleted['${model.habitId}-3'] ?? true,
                ),
              ];

        final isExpanded =
            _expandedHabitIds.contains(model.habitId.toString()) ||
            _expandedHabitIds.contains('1');

        return Habit(
          id: model.habitId.toString(),
          title: model.name,
          streakText: '${model.streak > 0 ? model.streak : 168} Days Streaks',
          icon: Icons.wb_sunny_rounded,
          iconBgColor: const Color(0xFFFFF1E8),
          iconColor: const Color(0xFFFF9500),
          statusType: HabitStatusType.progress,
          isExpanded: isExpanded,
          subHabits: subHabits,
        );
      } else if (index == 1) {
        return Habit(
          id: model.habitId.toString(),
          title: model.name,
          streakText: '${model.streak > 0 ? model.streak : 168} Days Streaks',
          icon: Icons.menu_book_rounded,
          iconBgColor: const Color(0xFFEAF8EE),
          iconColor: const Color(0xFF22C55E),
          statusType: HabitStatusType.completedPill,
          isExpanded: false,
        );
      } else {
        return Habit(
          id: model.habitId.toString(),
          title: model.name,
          streakText: '${model.streak > 0 ? model.streak : 168} Days Streaks',
          icon: Icons.directions_run_rounded,
          iconBgColor: const Color(0xFFE6F8FA),
          iconColor: const Color(0xFF00B4D8),
          statusType: isCompleted
              ? HabitStatusType.completedPill
              : HabitStatusType.doneOutlinedPill,
          isExpanded: false,
        );
      }
    });
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
      backgroundColor: colors.pageBackground,
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
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
                          Text(
                            'Today’s Progress',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colors.primaryText,
                            ),
                          ),
                          Text(
                            'Keep going! You’re doing great.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                            svgAsset: LifeSyncSvgAssets.taskEdit,
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
              const SizedBox(height: 14),
              Row(
                children: [
                  _HomeQuickAction(
                    icon: Icons.timer_outlined,
                    label: 'Focus',
                    onTap: () => Get.toNamed<void>(AppRoutes.focusTimer),
                  ),
                  const SizedBox(width: 8),
                  _HomeQuickAction(
                    icon: Icons.edit_note_rounded,
                    label: 'Journal',
                    onTap: () => Get.toNamed<void>(AppRoutes.journal),
                  ),
                  const SizedBox(width: 8),
                  _HomeQuickAction(
                    icon: Icons.calendar_month_rounded,
                    label: 'Calendar',
                    onTap: () => Get.toNamed<void>(AppRoutes.calendar),
                  ),
                  const SizedBox(width: 8),
                  _HomeQuickAction(
                    icon: Icons.emoji_events_outlined,
                    label: 'Progress',
                    onTap: () => Get.toNamed<void>(AppRoutes.personalProgress),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                child: Obx(() {
                  final tasks = _tasks.todayTasks;
                  final remaining = tasks
                      .where((task) => !task.isCompleted)
                      .length;
                  final isEmpty = tasks.isEmpty;
                  return Column(
                    children: [
                      _SectionHeader(
                        title: 'Today’s Tasks',
                        subtitle: isEmpty
                            ? 'No tasks assigned for today.'
                            : '$remaining remaining',
                        action: TextButton.icon(
                          onPressed: () =>
                              Get.toNamed<void>(AppRoutes.taskEditor),
                          icon: const Icon(Icons.add, size: 17),
                          label: const Text('Add Task'),
                        ),
                      ),
                      if (isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: SvgPicture.asset(
                              LifeSyncSvgAssets.group,
                              width: 167,
                              height: 89,
                              fit: BoxFit.contain,
                            ),
                          ),
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
              Obx(() {
                final habits = _habits.todayHabits;
                if (habits.isEmpty) {
                  return _SectionCard(
                    child: Column(
                      children: [
                        _SectionHeader(
                          title: 'Habits',
                          subtitle: 'No habits scheduled today.',
                          action: TextButton(
                            onPressed: () =>
                                Get.toNamed<void>(AppRoutes.habits),
                            child: const Text('View All'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Center(
                            child: SvgPicture.asset(
                              LifeSyncSvgAssets.activityTracker,
                              width: 150,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'Alright, what habit are we starting? ',
                                style: TextStyle(
                                  color: context.lifeSyncColors.secondaryText,
                                  fontSize: 13,
                                ),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: GestureDetector(
                                      onTap: () => Get.toNamed<void>(
                                        AppRoutes.habitEditor,
                                      ),
                                      child: Text(
                                        'Create one',
                                        style: TextStyle(
                                          color: context
                                              .lifeSyncColors
                                              .primaryBlue,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final displayHabits = _mapTodayHabits(habits);
                return HabitsCard(
                  habits: displayHabits,
                  onAddSchedule: () => Get.toNamed<void>(AppRoutes.habitEditor),
                  onViewAll: () => Get.toNamed<void>(AppRoutes.habits),
                  onHabitTap: (habit) => Get.toNamed<void>(AppRoutes.habits),
                  onToggleExpand: _toggleExpand,
                  onSubItemToggle: _toggleSubItem,
                );
              }),
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
        color: colors.cardSurface,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.primaryText,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    required this.value,
    required this.label,
    this.icon,
    this.svgAsset,
  });
  final IconData? icon;
  final String? svgAsset;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Row(
      children: [
        if (svgAsset != null)
          SvgPicture.asset(
            svgAsset!,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
          )
        else if (icon != null)
          Icon(icon, color: colors.primaryBlue, size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colors.primaryText,
              ),
            ),
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

final class _HomeQuickAction extends StatelessWidget {
  const _HomeQuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors.primaryBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: colors.primaryBlue),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
