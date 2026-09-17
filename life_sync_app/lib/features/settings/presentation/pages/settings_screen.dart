import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/app_preferences_service.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/core/theme/theme_controller.dart';
import 'package:life_sync_app/features/goals/presentation/controllers/goal_controller.dart';
import 'package:life_sync_app/features/habits/presentation/controllers/habit_controller.dart';
import 'package:life_sync_app/features/journal/presentation/controllers/journal_controller.dart';
import 'package:life_sync_app/features/tasks/presentation/controllers/task_controller.dart';
import 'package:life_sync_app/features/user/presentation/controllers/profile_controller.dart';

final class SettingsScreen extends StatelessWidget {
  const SettingsScreen({this.onBackPressed, super.key});

  final VoidCallback? onBackPressed;

  Future<void> _selectTheme(BuildContext context) async {
    final controller = Get.find<ThemeController>();
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Appearance', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                ...ThemePreference.values.map(
                  (value) => ListTile(
                    selected: controller.preference.value == value,
                    title: Text(value.name.capitalizeFirst!),
                    leading: Icon(switch (value) {
                      ThemePreference.light => Icons.light_mode_outlined,
                      ThemePreference.dark => Icons.dark_mode_outlined,
                      ThemePreference.system =>
                        Icons.settings_brightness_outlined,
                    }),
                    trailing: Icon(
                      controller.preference.value == value
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                    ),
                    onTap: () => controller.select(value),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectFirstDay(BuildContext context) async {
    final controller = Get.find<AppPreferencesService>();
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'First day of the week',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                ...FirstDayOfWeek.values.map(
                  (value) => ListTile(
                    selected: controller.firstDayOfWeek.value == value,
                    title: Text(value.name.capitalizeFirst!),
                    trailing: Icon(
                      controller.firstDayOfWeek.value == value
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                    ),
                    onTap: () => controller.setFirstDay(value),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'Local journals and focus history stay on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await Get.find<AuthSessionService>().clearSession();
    await Get.offAllNamed<void>(AppRoutes.signIn);
  }

  void _unavailable(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final profile = Get.find<ProfileController>();
    final tasks = Get.find<TaskController>();
    final habits = Get.find<HabitController>();
    final goals = Get.find<GoalController>();
    final journals = Get.find<JournalController>();
    final theme = Get.find<ThemeController>();
    final preferences = Get.find<AppPreferencesService>();

    final colors = context.lifeSyncColors;
    final primaryBlue = colors.primaryBlue;
    final cardBgColor = colors.cardSurface;

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: Obx(() {
          final userName =
              profile.state.value.data?.fullName ?? 'LifeSync user';
          final userEmail =
              profile.state.value.data?.email ?? 'Profile unavailable';
          final avatarBytes = profile.imageBytes.value;
          final appearance = theme.preference.value.name.capitalizeFirst!;
          final firstDay =
              preferences.firstDayOfWeek.value.name.capitalizeFirst!;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // Top Bar
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      if (onBackPressed != null) {
                        onBackPressed!();
                      } else if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Get.offAllNamed<void>(AppRoutes.shell);
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colors.cardSurface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: colors.primaryText,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Setting',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colors.primaryText,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
              const SizedBox(height: 24),

              // Profile Card
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Get.toNamed<void>(AppRoutes.profile),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: colors.elevatedSurface,
                        backgroundImage: avatarBytes != null
                            ? MemoryImage(avatarBytes)
                            : null,
                        child: avatarBytes == null
                            ? Icon(
                                Icons.person_rounded,
                                size: 30,
                                color: colors.secondaryText,
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: colors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.secondaryText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: colors.secondaryText,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick Stats Row
              Row(
                children: [
                  _StatCard(
                    icon: Icons.assignment_outlined,
                    label: 'Tasks',
                    count: tasks.tasks.length,
                    color: primaryBlue,
                    onTap: () => Get.toNamed<void>(AppRoutes.tasks),
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    icon: Icons.track_changes_outlined,
                    label: 'Goals',
                    count: goals.goals.length,
                    color: primaryBlue,
                    onTap: () => Get.toNamed<void>(AppRoutes.goalEditor),
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    icon: Icons.event_repeat_rounded,
                    label: 'Habit',
                    count: habits.habits.length,
                    color: primaryBlue,
                    onTap: () => Get.toNamed<void>(AppRoutes.habits),
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    icon: Icons.edit_note_rounded,
                    label: 'Journal',
                    count: journals.entries.length,
                    color: primaryBlue,
                    onTap: () => Get.toNamed<void>(AppRoutes.journal),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Settings Header
              Text(
                'Settings & Personalization',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.primaryText,
                ),
              ),
              const SizedBox(height: 12),

              // Settings Options Group
              Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _SettingRow(
                      icon: Icons.brush_outlined,
                      title: 'Appearance',
                      value: appearance,
                      onTap: () => _selectTheme(context),
                    ),
                    _SettingRow(
                      icon: Icons.calendar_today_outlined,
                      title: 'First Day of the Week',
                      value: firstDay,
                      onTap: () => _selectFirstDay(context),
                    ),
                    _SettingRow(
                      icon: Icons.language_rounded,
                      title: 'Language',
                      value: 'English',
                      onTap: () => _unavailable(
                        context,
                        'English is the only supported language currently.',
                      ),
                    ),
                    _SettingRow(
                      icon: Icons.lock_outline_rounded,
                      title: 'Add Passcode',
                      onTap: () => _unavailable(
                        context,
                        'Device passcode protection is not available yet. Your account password is unchanged.',
                      ),
                    ),
                    _SettingRow(
                      icon: Icons.notifications_none_rounded,
                      title: 'Reminder',
                      onTap: () => Get.toNamed<void>(AppRoutes.notifications),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Log Out Tile
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _logout(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFEF4444),
                        size: 22,
                      ),
                      SizedBox(width: 14),
                      Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Productivity & More Tools Group
              Text(
                'Productivity & More Tools',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.primaryText,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _SettingRow(
                      icon: Icons.edit_note_rounded,
                      title: 'Journal',
                      value: '${journals.entries.length} entries',
                      onTap: () => Get.toNamed<void>(AppRoutes.journal),
                    ),
                    _SettingRow(
                      icon: Icons.timer_outlined,
                      title: 'Pomodoro & Stopwatch',
                      onTap: () => Get.toNamed<void>(AppRoutes.focusTimer),
                    ),
                    _SettingRow(
                      icon: Icons.insights_rounded,
                      title: 'Focus Statistics',
                      onTap: () => Get.toNamed<void>(AppRoutes.focusStatistics),
                    ),
                    _SettingRow(
                      icon: Icons.calendar_month_rounded,
                      title: 'Calendar',
                      onTap: () => Get.toNamed<void>(AppRoutes.calendar),
                    ),
                    _SettingRow(
                      icon: Icons.emoji_events_outlined,
                      title: 'Personal Progress & Wins',
                      onTap: () =>
                          Get.toNamed<void>(AppRoutes.personalProgress),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        }),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    this.onTap,
  });

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
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18, color: color),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
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

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  const _SettingRow({
    required this.icon,
    required this.title,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: colors.primaryBlue),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colors.primaryText,
                ),
              ),
            ),
            if (value != null) ...[
              Text(
                value!,
                style: TextStyle(fontSize: 14, color: colors.secondaryText),
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: colors.secondaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
