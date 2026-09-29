import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/config/app_environment.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/services/notification_delivery_service.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';
import 'package:life_sync_app/features/tasks/data/models/task_models.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';

HabitModel habit({bool active = true, String frequency = 'DAILY'}) =>
    HabitModel(
      habitId: 1,
      userId: 1,
      name: 'Private habit',
      frequency: frequency,
      streak: 0,
      active: active,
    );

TaskModel task(int id, DateTime date, {bool completed = false}) => TaskModel(
  id: id,
  title: 'Private task',
  priority: TaskPriority.normal,
  status: completed ? TaskStatus.completed : TaskStatus.pending,
  dueDate: date,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('overdue tasks use next daily time, completed tasks excluded', () {
    final now = DateTime(2026, 9, 29, 23, 48);
    final plan = taskReminderPlan(
      [task(1, now), task(2, now, completed: true)],
      now,
      9,
      0,
      includeOverdue: true,
    );
    expect(plan, {1: DateTime(2026, 9, 30, 9)});
  });
  test('habit plan respects frequency, pause and completion', () {
    final now = DateTime(2026, 9, 29, 8);
    expect(habitReminderPlan([habit(active: false)], [], now, 9, 0), isEmpty);
    final weekly = habitReminderPlan(
      [habit(frequency: 'WEEKLY:MON')],
      [],
      now,
      9,
      0,
    );
    expect(weekly.values.single, DateTime(2026, 10, 5, 9));
    final logs = [
      HabitLogModel(
        habitLogId: 1,
        habitId: 1,
        userId: 1,
        completedDate: now,
        completed: true,
        note: '',
      ),
    ];
    expect(habitReminderPlan([habit()], logs, now, 9, 0).length, 6);
  });
  test(
    'plan excludes past and completed tasks, sorts and caps pending alarms',
    () {
      final now = DateTime(2026, 9, 30, 8);
      final plan = taskReminderPlan(
        [
          task(1, now.subtract(const Duration(days: 1))),
          task(2, now, completed: true),
          task(3, now),
          ...List.generate(
            120,
            (index) => task(index + 4, now.add(Duration(days: index + 1))),
          ),
        ],
        now,
        9,
        30,
      );
      expect(plan.length, 100);
      expect(plan.keys.first, 3);
      expect(plan[3], DateTime(2026, 9, 30, 9, 30));
      expect(plan.containsKey(1), false);
      expect(plan.containsKey(2), false);
    },
  );

  late _Device device;
  late AuthSessionService session;
  late NotificationDeliveryService service;
  setUp(() async {
    final store = _Store();
    final tokens = SecureTokenStorage(store);
    session = AuthSessionService(tokens);
    await session.saveSession(
      const StoredAuthSession(
        accessToken: 'test-only',
        tokenType: 'Bearer',
        userId: 1,
      ),
    );
    device = _Device();
    final api = ApiClient(
      environment: AppEnvironment(apiBaseUrl: 'https://example.invalid'),
      tokenStorage: tokens,
      onUnauthorized: session.handleUnauthorized,
      dio: Dio()..httpClientAdapter = _Adapter(),
    );
    service = NotificationDeliveryService(store, session, api, device);
    service.onInit();
    await service.updateTasks([]);
  });
  tearDown(() => service.onClose());

  test(
    'permission denial leaves reminders off and explains next step',
    () async {
      device.allowed = false;
      await service.setEnabled(true);
      expect(service.enabled.value, false);
      expect(service.error.value, contains('Android settings'));
      expect(device.pending, isEmpty);
    },
  );

  test('task completion and deletion cancel pending reminders', () async {
    await service.setEnabled(true);
    final future = DateTime.now().add(const Duration(days: 2));
    await service.updateTasks([task(1, future), task(2, future)]);
    expect(device.pending.keys.toSet(), {1, 2});
    await service.updateTasks([task(1, future, completed: true)]);
    expect(device.pending, isEmpty);
  });

  test('logout cancels reminders and disables account delivery', () async {
    await service.setEnabled(true);
    await service.updateTasks([
      task(1, DateTime.now().add(const Duration(days: 1))),
    ]);
    await session.clearSession();
    await service.updateTasks([]);
    expect(device.pending, isEmpty);
    expect(service.enabled.value, false);
  });

  test('habit pause and deletion cancel only habit alarms', () async {
    await service.setEnabled(true);
    await service.updateTasks([
      task(1, DateTime.now().add(const Duration(days: 1))),
    ]);
    await service.updateHabits([habit()], []);
    expect(device.pending.keys.where(isHabitReminderId), isNotEmpty);
    await service.updateHabits([habit(active: false)], []);
    expect(device.pending.keys.toSet(), {1});
    await service.updateHabits([habit()], []);
    await service.updateHabits([], []);
    expect(device.pending.keys.toSet(), {1});
  });

  test('test notification requires enablement and can be scheduled', () async {
    await service.testNotification();
    expect(device.shown, 0);
    await service.setEnabled(true);
    await service.testNotification();
    expect(device.shown, 1);
    await service.testNotification(delayed: true);
    expect(device.pending[-1], isNotNull);
  });
}

class _Store implements SecureKeyValueStore {
  final values = <String, String>{};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }
}

class _Device implements NotificationDevice {
  bool allowed = true;
  final pending = <int, DateTime>{};
  int shown = 0;
  @override
  bool get supported => true;
  @override
  Future<void> initialize(void Function(String?) onTap) async {}
  @override
  Future<bool> isAllowed() async => allowed;
  @override
  Future<bool> requestPermission() async => allowed;
  @override
  Future<void> openSettings() async {}
  @override
  Future<void> cancelAll() async => pending.clear();
  @override
  Future<void> cancel(int id) async {
    pending.remove(id);
  }

  @override
  Future<List<int>> pendingIds() async => pending.keys.toList();
  @override
  Future<void> schedule(
    int id,
    DateTime when,
    String title,
    String body,
  ) async {
    pending[id] = when;
  }

  @override
  Future<void> show(int id, String title, String body) async {
    shown++;
  }
}

class _Adapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    '[]',
    200,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}
