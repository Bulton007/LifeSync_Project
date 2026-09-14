import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/app_preferences_service.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/features/settings/presentation/widgets/settings_layout.dart';
import 'package:life_sync_app/core/theme/theme_controller.dart';
import 'package:life_sync_app/features/goals/presentation/controllers/goal_controller.dart';
import 'package:life_sync_app/features/habits/presentation/controllers/habit_controller.dart';
import 'package:life_sync_app/features/journal/presentation/controllers/journal_controller.dart';
import 'package:life_sync_app/features/tasks/presentation/controllers/task_controller.dart';
import 'package:life_sync_app/features/user/presentation/controllers/profile_controller.dart';

final class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
    return Obx(
      () => SettingsLayout(
        name: profile.state.value.data?.fullName ?? 'LifeSync user',
        email: profile.state.value.data?.email ?? 'Profile unavailable',
        avatar: profile.imageBytes.value,
        counts: [
          tasks.tasks.length,
          goals.goals.length,
          habits.habits.length,
          journals.entries.length,
        ],
        appearance: theme.preference.value.name.capitalizeFirst!,
        firstDay: preferences.firstDayOfWeek.value.name.capitalizeFirst!,
        onBack: () => Navigator.of(context).maybePop(),
        onProfile: () => Get.toNamed<void>(AppRoutes.profile),
        onAppearance: () => _selectTheme(context),
        onFirstDay: () => _selectFirstDay(context),
        onLanguage: () => _unavailable(
          context,
          'English is the only supported language currently.',
        ),
        onPasscode: () => _unavailable(
          context,
          'Device passcode protection is not available yet. Your account password is unchanged.',
        ),
        onReminder: () => Get.toNamed<void>(AppRoutes.notifications),
        onLogout: () => _logout(context),
        more: ExpansionTile(
          title: const Text('More tools', style: TextStyle(fontSize: 13)),
          children: [
            ListTile(
              title: const Text('Journal'),
              onTap: () => Get.toNamed<void>(AppRoutes.journal),
            ),
            ListTile(
              title: const Text('Pomodoro & Stopwatch'),
              onTap: () => Get.toNamed<void>(AppRoutes.focusTimer),
            ),
            ListTile(
              title: const Text('Calendar'),
              onTap: () => Get.toNamed<void>(AppRoutes.calendar),
            ),
            ListTile(
              title: const Text('Personal progress'),
              onTap: () => Get.toNamed<void>(AppRoutes.personalProgress),
            ),
          ],
        ),
      ),
    );
  }
}
