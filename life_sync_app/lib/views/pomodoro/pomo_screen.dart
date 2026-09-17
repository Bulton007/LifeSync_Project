import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/focus_sound_service.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';
import 'package:life_sync_app/features/focus/data/models/focus_session.dart';
import 'package:life_sync_app/features/focus/presentation/controllers/focus_controller.dart';
import 'package:life_sync_app/features/tasks/presentation/controllers/task_controller.dart';

final class PomoScreen extends StatefulWidget {
  const PomoScreen({super.key});

  @override
  State<PomoScreen> createState() => _PomoScreenState();
}

final class _PomoScreenState extends State<PomoScreen> {
  late final FocusController _controller;
  Worker? _completionWorker;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<FocusController>();
    _controller.loadSessions();
    _completionWorker = ever(_controller.completionSignal, (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pomodoro complete. Great focus!')),
      );
    });
  }

  @override
  void dispose() {
    _completionWorker?.dispose();
    super.dispose();
  }

  String _duration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    if (isToday) {
      return 'Today, $hour:$minute $ampm';
    }
    return '${dt.month}/${dt.day}, $hour:$minute $ampm';
  }

  void _switchMode(FocusMode mode) {
    if (_controller.switchMode(mode)) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Stop or reset the active timer before changing mode.'),
      ),
    );
  }

  Future<void> _chooseTask() async {
    final taskController = Get.isRegistered<TaskController>()
        ? Get.find<TaskController>()
        : null;
    final tasks = taskController?.tasks ?? const [];
    final selected = await showModalBottomSheet<String?>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            const Text('Working on', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.close_rounded),
              title: const Text('No associated task'),
              onTap: () => Navigator.pop(context, ''),
            ),
            if (tasks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No tasks are currently available.'),
              )
            else
              ...tasks.map(
                (task) => ListTile(
                  leading: const Icon(Icons.task_alt_rounded),
                  title: Text(task.title),
                  onTap: () => Navigator.pop(context, task.title),
                ),
              ),
          ],
        ),
      ),
    );
    if (selected != null) _controller.selectTask(selected);
  }

  Future<void> _chooseSound() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            const Text(
              'Focus Sound & Ambience',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...FocusSoundService.availableSounds.map(
              (sound) => Obx(
                () => ListTile(
                  leading: const Icon(Icons.music_note_rounded),
                  title: Text(sound),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Preview sound',
                        icon: const Icon(Icons.volume_up_rounded),
                        onPressed: () => FocusSoundService.play(sound),
                      ),
                      if (_controller.selectedSound.value == sound)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF1E88E5),
                        ),
                    ],
                  ),
                  onTap: () {
                    _controller.selectSound(sound);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _stop() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop this focus session?'),
        content: const Text(
          'Elapsed focus time will be saved to your local database.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continue'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Stop and Record'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _controller.stopAndSave();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Session recorded with ${_controller.selectedSound.value}!',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            children: [
              Row(
                children: [
                  Material(
                    color: colors.navigationSelected,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Back',
                      onPressed: Get.back<void>,
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                  ),
                  const Spacer(),
                  IconButton.outlined(
                    tooltip: 'Focus statistics',
                    onPressed: () =>
                        Get.toNamed<void>(AppRoutes.focusStatistics),
                    icon: Icon(
                      Icons.pie_chart_outline_rounded,
                      color: colors.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.cardSurface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: colors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ModeTab(
                          label: 'Pomodoro',
                          selected:
                              _controller.mode.value == FocusMode.pomodoro,
                          onTap: () => _switchMode(FocusMode.pomodoro),
                        ),
                        _ModeTab(
                          label: 'Stopwatch',
                          selected:
                              _controller.mode.value == FocusMode.stopwatch,
                          onTap: () => _switchMode(FocusMode.stopwatch),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Task & Sound Controls Row
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  Obx(
                    () => ActionChip(
                      avatar: const Icon(Icons.task_alt_rounded, size: 16),
                      label: Text(
                        _controller.taskName.value ?? 'Choose Task',
                        style: const TextStyle(fontSize: 12),
                      ),
                      onPressed: _controller.hasActiveSession ? null : _chooseTask,
                    ),
                  ),
                  Obx(
                    () => ActionChip(
                      avatar: const Icon(Icons.music_note_rounded, size: 16),
                      label: Text(
                        _controller.selectedSound.value,
                        style: const TextStyle(fontSize: 12),
                      ),
                      onPressed: _chooseSound,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Obx(() {
                final progress = _controller.progress;
                return Container(
                  width: 250,
                  height: 250,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors.glow,
                        blurRadius: 36,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 3,
                        backgroundColor: colors.border,
                        color: colors.primaryBlue,
                      ),
                      Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: Text(
                            _duration(_controller.displaySeconds),
                            key: ValueKey(_controller.displaySeconds),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 28),
              Obx(() {
                final running = _controller.isRunning.value;
                final active = _controller.hasActiveSession;
                if (!active) {
                  return SizedBox(
                    width: 140,
                    height: 44,
                    child: FilledButton.icon(
                      onPressed: _controller.start,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Start'),
                    ),
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.outlined(
                      tooltip: 'Reset without saving',
                      onPressed: _controller.reset,
                      icon: const Icon(Icons.restart_alt_rounded),
                    ),
                    const SizedBox(width: 18),
                    IconButton.filled(
                      tooltip: running ? 'Pause' : 'Resume',
                      onPressed: running
                          ? _controller.pause
                          : _controller.start,
                      icon: Icon(
                        running
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                    ),
                    const SizedBox(width: 18),
                    IconButton.outlined(
                      tooltip: 'Stop and record',
                      onPressed: _stop,
                      icon: const Icon(Icons.stop_rounded),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 36),

              // RECORDED SESSIONS SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recorded Sessions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        Get.toNamed<void>(AppRoutes.focusStatistics),
                    icon: const Icon(Icons.bar_chart_rounded, size: 16),
                    label: const Text('View Stats'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Obx(() {
                final sessions = _controller.sessions;
                if (sessions.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: colors.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 36,
                          color: colors.disabledText,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No recorded sessions yet.',
                          style: TextStyle(
                            color: colors.secondaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Press Start, then Stop to record your session here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors.disabledText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sessions.take(6).length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: colors.navigationSelected,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              session.completed
                                  ? Icons.check_circle_rounded
                                  : Icons.timer_outlined,
                              color: colors.primaryBlue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  session.taskName?.isNotEmpty == true
                                      ? session.taskName!
                                      : (session.mode == FocusMode.pomodoro
                                          ? 'Pomodoro Focus'
                                          : 'Stopwatch Session'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_duration(session.durationSeconds)} • ${_formatDateTime(session.startedAt)}',
                                  style: TextStyle(
                                    color: colors.secondaryText,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _controller.playSessionSound(session.soundName);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Text(
                                    'Playing sound: ${session.soundName ?? 'Focus Bell'}',
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colors.navigationSelected,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.volume_up_rounded,
                                    size: 16,
                                    color: colors.primaryBlue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    session.soundName ?? 'Focus Bell',
                                    style: TextStyle(
                                      color: colors.primaryBlue,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? colors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : colors.secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
