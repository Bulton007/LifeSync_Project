import 'package:life_sync_app/views/pomodoro/focus_duration_sheet.dart';
import 'dart:math' as math;
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
        SnackBar(content: Text('Pomodoro complete. Great focus!'.tr)),
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
      SnackBar(
        content: Text(
          'Stop or reset the active timer before changing mode.'.tr,
        ),
      ),
    );
  }

  Future<void> _chooseTask() async {
    final taskController = Get.isRegistered<TaskController>()
        ? Get.find<TaskController>()
        : null;
    final tasks = taskController?.tasks ?? [];
    final selected = await showModalBottomSheet<String?>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            Text('Working on'.tr, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.close_rounded),
              title: Text('No associated task'.tr),
              onTap: () => Navigator.pop(context, ''),
            ),
            if (tasks.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('No tasks are currently available.'.tr),
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
            Text(
              'Focus Sound & Ambience'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        tooltip: 'Preview sound'.tr,
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
        title: Text('Stop this focus session?'.tr),
        content: Text(
          'Elapsed focus time will be saved to your local database.'.tr,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Continue'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Stop and Record'.tr),
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

  Future<void> _chooseDuration() async {
    if (_controller.hasActiveSession) return;
    final minutes = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) =>
          FocusDurationSheet(initialMinutes: _controller.pomodoroSeconds ~/ 60),
    );
    if (minutes != null) {
      try {
        await _controller.setDurationMinutes(minutes);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unable to save duration.'.tr)),
          );
        }
      }
    }
  }

  Future<void> _reset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset without saving'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Reset'.tr),
          ),
        ],
      ),
    );
    if (confirmed == true) _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      backgroundColor: colors.cardSurface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final diameter = math.min(290.0, constraints.maxWidth - 64);
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: math.max(0, constraints.maxHeight - 36),
                ),
                child: Obx(() {
                  final active = _controller.hasActiveSession;
                  final running = _controller.isRunning.value;
                  final stopwatch =
                      _controller.mode.value == FocusMode.stopwatch;
                  return Column(
                    children: [
                      Row(
                        children: [
                          IconButton.filledTonal(
                            tooltip: 'Back'.tr,
                            onPressed: Get.back<void>,
                            icon: const Icon(Icons.chevron_left),
                          ),
                          const Spacer(),
                          IconButton.outlined(
                            tooltip: 'Focus statistics'.tr,
                            key: const ValueKey('focus-statistics'),
                            onPressed: () =>
                                Get.toNamed<void>(AppRoutes.focusStatistics),
                            icon: Icon(
                              Icons.pie_chart_rounded,
                              color: colors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (!active)
                        Container(
                          decoration: BoxDecoration(
                            color: colors.inputSurface,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: colors.border),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              _ModeTab(
                                label: 'Pomodoro'.tr,
                                selected: !stopwatch,
                                onTap: () => _switchMode(FocusMode.pomodoro),
                              ),
                              _ModeTab(
                                label: 'Stopwatch'.tr,
                                selected: stopwatch,
                                onTap: () => _switchMode(FocusMode.stopwatch),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: active ? 20 : 26),
                      Text(
                        (active ? 'Working on' : 'Work on').tr,
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.secondaryText,
                        ),
                      ),
                      TextButton(
                        key: const ValueKey('focus-task'),
                        onPressed: active ? null : _chooseTask,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                _controller.taskName.value ?? 'Choose Task'.tr,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colors.primaryText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.unfold_more,
                              size: 15,
                              color: colors.secondaryText,
                            ),
                          ],
                        ),
                      ),
                      if (!stopwatch && !active)
                        TextButton.icon(
                          key: const ValueKey('edit-focus-duration'),
                          onPressed: _chooseDuration,
                          icon: const Icon(Icons.tune, size: 16),
                          label: Text(
                            'Focus duration'.tr,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      SizedBox(
                        height: math.max(20, constraints.maxHeight * .045),
                      ),
                      Semantics(
                        label: 'Focus timer'.tr,
                        value: _duration(_controller.displaySeconds),
                        child: GestureDetector(
                          onTap: !active && !stopwatch ? _chooseDuration : null,
                          child: Container(
                            width: diameter,
                            height: diameter,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.inputSurface,
                              boxShadow: [
                                BoxShadow(
                                  color: colors.primaryBlue.withValues(
                                    alpha: .16,
                                  ),
                                  blurRadius: 55,
                                  spreadRadius: 22,
                                ),
                              ],
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (stopwatch)
                                  CustomPaint(
                                    painter: _ClockTicks(
                                      colors.border,
                                      colors.primaryBlue,
                                      _controller.progress,
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.all(stopwatch ? 5 : 0),
                                  child: CircularProgressIndicator(
                                    value: _controller.progress,
                                    strokeWidth: 3,
                                    backgroundColor: Colors.transparent,
                                    color: colors.primaryBlue,
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    _duration(_controller.displaySeconds),
                                    key: const ValueKey('focus-time'),
                                    style: TextStyle(
                                      fontSize: diameter < 250 ? 32 : 38,
                                      fontWeight: FontWeight.w300,
                                      color: colors.primaryText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: math.max(40, constraints.maxHeight * .085),
                      ),
                      if (!active)
                        SizedBox(
                          width: 140,
                          height: 46,
                          child: FilledButton(
                            key: const ValueKey('focus-start'),
                            onPressed: _controller.start,
                            child: Text('Start'.tr),
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton.outlined(
                              tooltip: 'Focus Sound & Ambience'.tr,
                              onPressed: _chooseSound,
                              icon: const Icon(Icons.music_note_outlined),
                            ),
                            const SizedBox(width: 18),
                            SizedBox(
                              width: 56,
                              height: 56,
                              child: IconButton.filled(
                                key: const ValueKey('focus-pause'),
                                tooltip: (running ? 'Pause' : 'Resume').tr,
                                onPressed: running
                                    ? _controller.pause
                                    : _controller.start,
                                icon: Icon(
                                  running
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            IconButton.outlined(
                              key: const ValueKey('focus-stop'),
                              tooltip: 'Stop and record'.tr,
                              onPressed: _stop,
                              icon: const Icon(Icons.stop_rounded),
                            ),
                          ],
                        ),
                      const SizedBox(height: 12),
                      if (active)
                        TextButton(
                          onPressed: _reset,
                          child: Text(
                            'Reset without saving'.tr,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.secondaryText,
                            ),
                          ),
                        )
                      else
                        TextButton.icon(
                          onPressed: _chooseSound,
                          icon: const Icon(Icons.music_note_outlined, size: 15),
                          label: Text(
                            _controller.selectedSound.value.tr,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      if (_controller.errorMessage.value != null)
                        Text(
                          'Unable to save or load focus sessions. Please try again.'
                              .tr,
                          style: TextStyle(color: colors.negative),
                        ),
                    ],
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ClockTicks extends CustomPainter {
  _ClockTicks(this.background, this.foreground, this.progress);
  final Color background;
  final Color foreground;
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 10;
    for (var tick = 0; tick < 60; tick++) {
      final angle = tick / 60 * math.pi * 2 - math.pi / 2;
      final length = tick % 5 == 0 ? 12.0 : 7.0;
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + direction * (radius - length),
        center + direction * radius,
        Paint()
          ..color = tick < progress * 60 ? foreground : background
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ClockTicks oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.background != background ||
      oldDelegate.foreground != foreground;
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
