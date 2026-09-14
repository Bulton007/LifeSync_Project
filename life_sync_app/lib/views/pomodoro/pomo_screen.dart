import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
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

  Future<void> _stop() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop this focus session?'),
        content: const Text(
          'Elapsed focus time will be saved to your local statistics.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continue'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Stop'),
          ),
        ],
      ),
    );
    if (confirmed == true) await _controller.stopAndSave();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
              const SizedBox(height: 28),
              Obx(
                () => InkWell(
                  onTap: _controller.hasActiveSession ? null : _chooseTask,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Working on',
                          style: TextStyle(
                            color: colors.secondaryText,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _controller.taskName.value ??
                                  'Choose a task (optional)',
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.unfold_more,
                              size: 15,
                              color: _controller.hasActiveSession
                                  ? colors.disabledText
                                  : colors.secondaryText,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Obx(() {
                final progress = _controller.progress;
                return Container(
                  width: 260,
                  height: 260,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors.glow,
                        blurRadius: 42,
                        spreadRadius: 10,
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
              const Spacer(),
              Obx(() {
                final running = _controller.isRunning.value;
                final active = _controller.hasActiveSession;
                if (!active) {
                  return SizedBox(
                    width: 132,
                    child: FilledButton(
                      onPressed: _controller.start,
                      child: const Text('Start'),
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
                      tooltip: 'Stop and save',
                      onPressed: _stop,
                      icon: const Icon(Icons.stop_rounded),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 18),
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
