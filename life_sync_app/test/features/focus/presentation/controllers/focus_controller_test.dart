import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/features/focus/data/models/focus_session.dart';
import 'package:life_sync_app/features/focus/domain/repositories/focus_repository.dart';
import 'package:life_sync_app/features/focus/presentation/controllers/focus_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('pomodoro start, pause, resume, reset use the injected clock', () async {
    final clock = _FakeClock(DateTime(2026, 9, 11, 10));
    final controller = FocusController(
      _MemoryFocusRepository(),
      _MemoryStore(),
      clock: clock,
      pomodoroSeconds: 1500,
    );

    await controller.start();
    clock.advance(const Duration(seconds: 61));
    await controller.pause();
    expect(controller.elapsedSeconds.value, 61);
    expect(controller.displaySeconds, 1439);

    await controller.start();
    clock.advance(const Duration(seconds: 9));
    await controller.pause();
    expect(controller.elapsedSeconds.value, 70);

    controller.reset();
    expect(controller.elapsedSeconds.value, 0);
    expect(controller.isRunning.value, isFalse);
    controller.onClose();
  });

  test('running state restores from timestamps after app suspension', () async {
    final store = _MemoryStore();
    final repository = _MemoryFocusRepository();
    final clock = _FakeClock(DateTime(2026, 9, 11, 10));
    final first = FocusController(repository, store, clock: clock);
    await first.start();
    clock.advance(const Duration(minutes: 2));

    final restored = FocusController(repository, store, clock: clock);
    await restored.restore();
    expect(restored.isRunning.value, isTrue);
    expect(restored.elapsedSeconds.value, 120);
    first.onClose();
    restored.onClose();
  });

  test('saved sessions calculate real filtered focus statistics', () async {
    final repository = _MemoryFocusRepository([
      FocusSession(
        id: 1,
        mode: FocusMode.pomodoro,
        startedAt: DateTime(2026, 9, 3),
        durationSeconds: 1500,
        completed: true,
      ),
      FocusSession(
        id: 2,
        mode: FocusMode.stopwatch,
        startedAt: DateTime(2026, 9, 4),
        durationSeconds: 300,
        completed: false,
      ),
    ]);
    final controller = FocusController(
      repository,
      _MemoryStore(),
      clock: _FakeClock(DateTime(2026, 9, 11)),
    );
    controller.periodAnchor.value = DateTime(2026, 9, 1);
    await controller.loadSessions();

    expect(controller.totalPomodoros, 1);
    expect(controller.totalFocusSeconds, 1800);
    expect(controller.dailySeconds, hasLength(2));
    controller.onClose();
  });
}

final class _FakeClock implements FocusClock {
  _FakeClock(this.value);
  DateTime value;

  void advance(Duration duration) => value = value.add(duration);

  @override
  DateTime now() => value;
}

final class _MemoryFocusRepository implements FocusRepository {
  _MemoryFocusRepository([List<FocusSession>? sessions])
    : _sessions = List.of(sessions ?? const []);

  final List<FocusSession> _sessions;

  @override
  Future<FocusSession> create(FocusSession session) async {
    final saved = session.copyWith(id: _sessions.length + 1);
    _sessions.add(saved);
    return saved;
  }

  @override
  Future<List<FocusSession>> readAll() async => List.of(_sessions);
}

final class _MemoryStore implements SecureKeyValueStore {
  final values = <String, String>{};

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}
