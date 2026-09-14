import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/features/focus/data/models/focus_session.dart';
import 'package:life_sync_app/features/focus/domain/repositories/focus_repository.dart';

abstract interface class FocusClock {
  DateTime now();
}

final class SystemFocusClock implements FocusClock {
  const SystemFocusClock();

  @override
  DateTime now() => DateTime.now();
}

enum FocusPeriod { month, quarter, year }

final class FocusController extends GetxController with WidgetsBindingObserver {
  FocusController(
    this._repository,
    this._store, {
    this._clock = const SystemFocusClock(),
    this.pomodoroSeconds = 25 * 60,
    this.ownerId = 0,
  });

  static const activeStateKey = 'focus.active_timer';

  final FocusRepository _repository;
  final SecureKeyValueStore _store;
  final FocusClock _clock;
  final int pomodoroSeconds;
  final int ownerId;

  String get _activeStateKey => '$activeStateKey.$ownerId';

  final mode = FocusMode.pomodoro.obs;
  final isRunning = false.obs;
  final elapsedSeconds = 0.obs;
  final taskName = RxnString();
  final sessions = <FocusSession>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final completionSignal = 0.obs;
  final period = FocusPeriod.month.obs;
  final periodAnchor = DateTime.now().obs;

  Timer? _ticker;
  DateTime? _segmentStartedAt;
  DateTime? _sessionStartedAt;
  int _accumulatedSeconds = 0;
  bool _completing = false;

  int get displaySeconds => mode.value == FocusMode.pomodoro
      ? (pomodoroSeconds - elapsedSeconds.value).clamp(0, pomodoroSeconds)
      : elapsedSeconds.value;

  double get progress => mode.value == FocusMode.pomodoro
      ? (elapsedSeconds.value / pomodoroSeconds).clamp(0, 1)
      : (elapsedSeconds.value % 60) / 60;

  bool get hasActiveSession => isRunning.value || elapsedSeconds.value > 0;

  List<FocusSession> get filteredSessions {
    final anchor = periodAnchor.value;
    DateTime start;
    DateTime end;
    switch (period.value) {
      case FocusPeriod.month:
        start = DateTime(anchor.year, anchor.month);
        end = DateTime(anchor.year, anchor.month + 1);
      case FocusPeriod.quarter:
        final startMonth = ((anchor.month - 1) ~/ 3) * 3 + 1;
        start = DateTime(anchor.year, startMonth);
        end = DateTime(anchor.year, startMonth + 3);
      case FocusPeriod.year:
        start = DateTime(anchor.year);
        end = DateTime(anchor.year + 1);
    }
    return sessions
        .where(
          (item) =>
              !item.startedAt.isBefore(start) && item.startedAt.isBefore(end),
        )
        .toList(growable: false);
  }

  int get totalPomodoros => filteredSessions
      .where((item) => item.mode == FocusMode.pomodoro && item.completed)
      .length;

  int get totalFocusSeconds =>
      filteredSessions.fold(0, (total, item) => total + item.durationSeconds);

  Map<DateTime, int> get dailySeconds {
    final result = <DateTime, int>{};
    for (final session in filteredSessions) {
      final day = DateTime(
        session.startedAt.year,
        session.startedAt.month,
        session.startedAt.day,
      );
      result[day] = (result[day] ?? 0) + session.durationSeconds;
    }
    return result;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    restore();
    loadSessions();
  }

  @override
  void onClose() {
    _ticker?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncFromClock();
      if (isRunning.value) _startTicker();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _ticker?.cancel();
      _ticker = null;
      _persist();
    }
  }

  Future<void> loadSessions() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      sessions.assignAll(await _repository.readAll());
    } on Object catch (error) {
      errorMessage.value = 'Focus history could not be loaded: $error';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> restore() async {
    final raw = await _store.read(_activeStateKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      mode.value = FocusMode.values.byName(data['mode']! as String);
      isRunning.value = data['running'] as bool? ?? false;
      _accumulatedSeconds = data['accumulated'] as int? ?? 0;
      _segmentStartedAt = _dateOrNull(data['segmentStartedAt']);
      _sessionStartedAt = _dateOrNull(data['sessionStartedAt']);
      taskName.value = data['taskName'] as String?;
      _syncFromClock();
      if (isRunning.value) _startTicker();
    } on Object {
      await _store.delete(_activeStateKey);
      reset();
    }
  }

  DateTime? _dateOrNull(Object? value) =>
      value is String ? DateTime.tryParse(value) : null;

  bool switchMode(FocusMode value) {
    if (mode.value == value) return true;
    if (hasActiveSession) return false;
    mode.value = value;
    elapsedSeconds.value = 0;
    _persist();
    return true;
  }

  void selectTask(String? value) {
    taskName.value = value?.trim().isEmpty ?? true ? null : value!.trim();
    _persist();
  }

  Future<void> start() async {
    if (isRunning.value) return;
    if (mode.value == FocusMode.pomodoro &&
        elapsedSeconds.value >= pomodoroSeconds) {
      reset();
    }
    final now = _clock.now();
    _sessionStartedAt ??= now;
    _segmentStartedAt = now;
    isRunning.value = true;
    _startTicker();
    await _persist();
  }

  Future<void> pause() async {
    if (!isRunning.value) return;
    _syncFromClock();
    _accumulatedSeconds = elapsedSeconds.value;
    _segmentStartedAt = null;
    isRunning.value = false;
    _ticker?.cancel();
    _ticker = null;
    await _persist();
  }

  Future<void> stopAndSave() async {
    _syncFromClock();
    final duration = elapsedSeconds.value;
    if (duration > 0) {
      await _recordSession(completed: false, duration: duration);
    }
    reset();
  }

  void reset() {
    _ticker?.cancel();
    _ticker = null;
    isRunning.value = false;
    elapsedSeconds.value = 0;
    _accumulatedSeconds = 0;
    _segmentStartedAt = null;
    _sessionStartedAt = null;
    _store.delete(_activeStateKey);
  }

  void previousPeriod() => _shiftPeriod(-1);

  void nextPeriod() => _shiftPeriod(1);

  void _shiftPeriod(int direction) {
    final anchor = periodAnchor.value;
    periodAnchor.value = switch (period.value) {
      FocusPeriod.month => DateTime(anchor.year, anchor.month + direction),
      FocusPeriod.quarter => DateTime(
        anchor.year,
        anchor.month + 3 * direction,
      ),
      FocusPeriod.year => DateTime(anchor.year + direction, anchor.month),
    };
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      _syncFromClock();
    });
  }

  void _syncFromClock() {
    var value = _accumulatedSeconds;
    if (isRunning.value && _segmentStartedAt != null) {
      value += _clock.now().difference(_segmentStartedAt!).inSeconds;
    }
    elapsedSeconds.value = value < 0 ? 0 : value;
    if (mode.value == FocusMode.pomodoro &&
        elapsedSeconds.value >= pomodoroSeconds &&
        !_completing) {
      _completePomodoro();
    }
  }

  Future<void> _completePomodoro() async {
    _completing = true;
    elapsedSeconds.value = pomodoroSeconds;
    _ticker?.cancel();
    _ticker = null;
    isRunning.value = false;
    await _recordSession(completed: true, duration: pomodoroSeconds);
    completionSignal.value++;
    reset();
    _completing = false;
  }

  Future<void> _recordSession({
    required bool completed,
    required int duration,
  }) async {
    final created = await _repository.create(
      FocusSession(
        id: null,
        mode: mode.value,
        taskName: taskName.value,
        startedAt: _sessionStartedAt ?? _clock.now(),
        durationSeconds: duration,
        completed: completed,
      ),
    );
    sessions.insert(0, created);
  }

  Future<void> _persist() {
    if (!hasActiveSession && taskName.value == null) {
      return _store.delete(_activeStateKey);
    }
    return _store.write(
      _activeStateKey,
      jsonEncode({
        'mode': mode.value.name,
        'running': isRunning.value,
        'accumulated': _accumulatedSeconds,
        'segmentStartedAt': _segmentStartedAt?.toIso8601String(),
        'sessionStartedAt': _sessionStartedAt?.toIso8601String(),
        'taskName': taskName.value,
      }),
    );
  }
}
