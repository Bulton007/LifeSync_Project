import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/features/notifications/data/models/notification_model.dart';
import 'package:life_sync_app/features/tasks/data/models/task_models.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';

bool isHabitReminderId(int id) => id <= -1000000000 && id >= -1000000006;

Map<int, DateTime> habitReminderPlan(
  List<HabitModel> habits,
  List<HabitLogModel> logs,
  DateTime now,
  int hour,
  int minute,
) {
  final plan = <int, DateTime>{};
  for (var offset = 0; offset < 7; offset++) {
    final when = DateTime(now.year, now.month, now.day + offset, hour, minute);
    if (!when.isAfter(now)) continue;
    final incomplete = habits.any(
      (habit) =>
          habit.active &&
          habit.isScheduledFor(when) &&
          !logs.any(
            (log) =>
                log.habitId == habit.habitId &&
                log.completed &&
                log.completedDate.year == when.year &&
                log.completedDate.month == when.month &&
                log.completedDate.day == when.day,
          ),
    );
    if (incomplete) plan[-1000000000 - (when.weekday - 1)] = when;
  }
  return plan;
}

abstract interface class NotificationDevice {
  bool get supported;
  Future<void> initialize(void Function(String?) onTap);
  Future<bool> requestPermission();
  Future<bool> isAllowed();
  Future<void> openSettings();
  Future<void> show(int id, String title, String body);
  Future<void> schedule(int id, DateTime when, String title, String body);
  Future<void> cancel(int id);
  Future<void> cancelAll();
  Future<List<int>> pendingIds();
}

final class AndroidNotificationDevice implements NotificationDevice {
  final _plugin = FlutterLocalNotificationsPlugin();
  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'lifesync_reminders',
      'LifeSync reminders',
      channelDescription: 'Task reminders and account alerts',
      importance: Importance.high,
      priority: Priority.high,
      visibility: NotificationVisibility.private,
    ),
  );
  @override
  bool get supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  @override
  Future<void> initialize(void Function(String?) onTap) async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
      ),
      onDidReceiveNotificationResponse: (response) => onTap(response.payload),
    );
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp == true) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => onTap(launch?.notificationResponse?.payload),
      );
    }
  }

  @override
  Future<bool> requestPermission() async =>
      await _android?.requestNotificationsPermission() ?? false;
  @override
  Future<bool> isAllowed() async =>
      await _android?.areNotificationsEnabled() ?? false;
  @override
  Future<void> openSettings() async {
    await _android?.openAppNotificationSettings();
  }

  @override
  Future<void> show(int id, String title, String body) => _plugin.show(
    id: id,
    title: title,
    body: body,
    notificationDetails: _details,
    payload: AppRoutes.notifications,
  );
  @override
  Future<void> schedule(int id, DateTime when, String title, String body) =>
      _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(when, tz.UTC),
        notificationDetails: _details,
        payload: isHabitReminderId(id)
            ? AppRoutes.habits
            : id > 0
            ? AppRoutes.tasks
            : AppRoutes.notifications,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);
  @override
  Future<void> cancelAll() => _plugin.cancelAll();
  @override
  Future<List<int>> pendingIds() async =>
      (await _plugin.pendingNotificationRequests())
          .map((item) => item.id)
          .toList();
}

Map<int, DateTime> taskReminderPlan(
  List<TaskModel> tasks,
  DateTime now,
  int hour,
  int minute, {
  bool includeOverdue = false,
}) {
  final candidates =
      tasks
          .where((task) => !task.isCompleted)
          .map(
            (task) => MapEntry(
              task.id,
              DateTime(
                task.dueDate.year,
                task.dueDate.month,
                task.dueDate.day,
                hour,
                minute,
              ),
            ),
          )
          .map((entry) {
            if (!includeOverdue || entry.value.isAfter(now)) return entry;
            var next = DateTime(now.year, now.month, now.day, hour, minute);
            if (!next.isAfter(now)) {
              next = DateTime(now.year, now.month, now.day + 1, hour, minute);
            }
            return MapEntry(entry.key, next);
          })
          .where((entry) => entry.value.isAfter(now))
          .toList()
        ..sort((first, second) => first.value.compareTo(second.value));
  return Map.fromEntries(candidates.take(100));
}

final class NotificationDeliveryService extends GetxService
    with WidgetsBindingObserver {
  NotificationDeliveryService(this.store, this.session, this.api, this.device);
  final SecureKeyValueStore store;
  final AuthSessionService session;
  final ApiClient api;
  final NotificationDevice device;
  final enabled = false.obs;
  final permissionGranted = false.obs;
  final hour = 9.obs;
  final minute = 0.obs;
  final error = RxnString();
  final scheduledCount = 0.obs;
  final scheduledHabitCount = 0.obs;
  final busy = false.obs;
  Timer? _timer;
  bool _initialized = false;
  bool _refreshing = false;
  int _generation = 0;
  int _taskRevision = 0;
  int _habitRevision = 0;
  String? _pendingRoute;
  Future<void> _operations = Future.value();
  String _key(int user, String suffix) => 'notifications.$user.$suffix';

  Future<void> _serialize(Future<void> Function() action) {
    _operations = _operations.then((_) => action()).catchError((Object _) {
      error.value = 'Notifications could not be updated. Please try again.';
    });
    return _operations;
  }

  @override
  void onInit() {
    super.onInit();
    if (!device.supported) return;
    WidgetsBinding.instance.addObserver(this);
    session.onSessionChanged = sessionChanged;
    sessionChanged();
  }

  void sessionChanged() {
    if (!session.isInitialized) return;
    final generation = ++_generation;
    enabled.value = false;
    _timer?.cancel();
    unawaited(
      _serialize(() async {
        if (!device.supported) return;
        if (!_initialized) {
          await device.initialize((route) {
            _pendingRoute =
                route == AppRoutes.tasks || route == AppRoutes.habits
                ? route
                : AppRoutes.notifications;
            openPendingNotification();
          });
          _initialized = true;
        }
        final user = session.currentSession?.userId;
        final previousOwner = await store.read('notifications.owner');
        if (user == null || previousOwner != '$user') await device.cancelAll();
        if (generation != _generation) return;
        scheduledCount.value = 0;
        scheduledHabitCount.value = 0;
        if (user == null) {
          _pendingRoute = null;
          await store.delete('notifications.owner');
          return;
        }
        await store.write('notifications.owner', '$user');
        final preference = await store.read(_key(user, 'enabled'));
        final savedHour =
            int.tryParse(await store.read(_key(user, 'hour')) ?? '') ?? 9;
        final savedMinute =
            int.tryParse(await store.read(_key(user, 'minute')) ?? '') ?? 0;
        if (generation != _generation) return;
        hour.value = savedHour.clamp(0, 23);
        minute.value = savedMinute.clamp(0, 59);
        enabled.value = preference == 'true';
        permissionGranted.value = await device.isAllowed();
        _updatePolling();
      }).then((_) => refresh()),
    );
  }

  Future<void> setEnabled(bool value) async {
    if (!device.supported || busy.value) return;
    busy.value = true;
    error.value = null;
    final generation = ++_generation;
    try {
      await _serialize(() async {
        final user = session.currentSession?.userId;
        if (user == null) return;
        permissionGranted.value = value
            ? await device.requestPermission()
            : await device.isAllowed();
        if (generation != _generation) return;
        enabled.value = value && permissionGranted.value;
        await store.write(_key(user, 'enabled'), '${enabled.value}');
        if (!enabled.value) {
          await device.cancelAll();
          scheduledCount.value = 0;
          scheduledHabitCount.value = 0;
        }
        if (value && !permissionGranted.value) {
          error.value =
              'Allow notifications in Android settings, then enable reminders again.';
        }
        _updatePolling();
      });
      await refresh();
    } finally {
      busy.value = false;
    }
  }

  Future<void> setTime(int newHour, int newMinute) async {
    final user = session.currentSession?.userId;
    if (user == null ||
        newHour < 0 ||
        newHour > 23 ||
        newMinute < 0 ||
        newMinute > 59) {
      return;
    }
    hour.value = newHour;
    minute.value = newMinute;
    await store.write(_key(user, 'hour'), '$newHour');
    await store.write(_key(user, 'minute'), '$newMinute');
    await refresh();
  }

  Future<void> testNotification({bool delayed = false}) async {
    await _serialize(() async {
      error.value = null;
      if (!enabled.value || !await device.isAllowed()) {
        error.value = 'Enable notifications first.';
        return;
      }
      if (delayed) {
        await device.schedule(
          -1,
          DateTime.now().add(const Duration(minutes: 1)),
          'LifeSync test',
          'Your scheduled reminder is working.',
        );
      } else {
        await device.show(
          -1,
          'LifeSync test',
          'Your notification permission and channel are working.',
        );
      }
    });
  }

  Future<void> refresh() async {
    final user = session.currentSession?.userId;
    final generation = _generation;
    final taskRevision = _taskRevision;
    final habitRevision = _habitRevision;
    if (!_initialized || _refreshing || !enabled.value || user == null) return;
    _refreshing = true;
    try {
      final taskResult = await api.get<List<TaskModel>>(
        '/api/tasks',
        decoder: (data) => (data as List)
            .map(
              (item) =>
                  TaskModel.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList(),
      );
      if (generation != _generation) return;
      final habitResult = await api.get<List<HabitModel>>(
        '/api/habits',
        decoder: (data) => (data as List)
            .map(
              (item) =>
                  HabitModel.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList(),
      );
      if (generation != _generation) return;
      final logResult = await api.get<List<HabitLogModel>>(
        '/api/habit-logs',
        decoder: (data) => (data as List)
            .map(
              (item) => HabitLogModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(),
      );
      if (generation != _generation) return;
      final inbox = await api.get<List<AppNotificationModel>>(
        '/api/notifications',
        decoder: (data) => (data as List)
            .map(
              (item) => AppNotificationModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(),
      );
      await _serialize(() async {
        if (generation != _generation || !enabled.value) return;
        permissionGranted.value = await device.isAllowed();
        if (!permissionGranted.value) {
          error.value =
              'Allow notifications in Android settings, then enable reminders again.';
          return;
        }
        error.value =
            taskResult.errorOrNull?.message ??
            habitResult.errorOrNull?.message ??
            logResult.errorOrNull?.message ??
            inbox.errorOrNull?.message;
        final tasks = taskResult.dataOrNull;
        if (tasks != null && taskRevision == _taskRevision) {
          await _applyTasks(tasks, generation);
        }
        if (habitRevision == _habitRevision &&
            habitResult.dataOrNull != null &&
            logResult.dataOrNull != null) {
          await _applyHabits(
            habitResult.dataOrNull!,
            logResult.dataOrNull!,
            generation,
          );
        }
        final items = inbox.dataOrNull;
        if (items != null) {
          var lastId =
              int.tryParse(await store.read(_key(user, 'lastId')) ?? '') ?? 0;
          final ordered = [...items]
            ..sort(
              (first, second) =>
                  first.notificationId.compareTo(second.notificationId),
            );
          for (final item in ordered) {
            if (generation != _generation) return;
            if (item.notificationId <= lastId) continue;
            if (!item.isRead &&
                DateTime.now().difference(item.createdAt).inDays < 1) {
              await device.show(
                -2,
                'LifeSync',
                'You have a new account alert.'.tr,
              );
            }
            lastId = item.notificationId;
            await store.write(_key(user, 'lastId'), '$lastId');
          }
        }
      });
    } catch (_) {
      error.value = 'Notifications could not be updated. Please try again.';
    } finally {
      _refreshing = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _timer?.cancel();
    if (state == AppLifecycleState.resumed) {
      unawaited(refresh());
      _updatePolling();
    }
  }

  Future<void> updateTasks(List<TaskModel> tasks) {
    _taskRevision++;
    final generation = _generation;
    return _serialize(() async {
      if (!_initialized || !enabled.value || generation != _generation) return;
      await _applyTasks(tasks, generation);
    });
  }

  void openPendingNotification() {
    final route = _pendingRoute;
    if (route == null ||
        !session.isAuthenticated ||
        Get.key.currentState == null ||
        !Get.currentRoute.startsWith('/app') &&
            !Get.currentRoute.startsWith('/tasks') &&
            !Get.currentRoute.startsWith('/habits') &&
            !Get.currentRoute.startsWith('/notifications') &&
            !Get.currentRoute.startsWith('/settings')) {
      return;
    }
    _pendingRoute = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (session.isAuthenticated) Get.toNamed<void>(route);
    });
  }

  Future<void> _applyTasks(List<TaskModel> tasks, int generation) async {
    final plan = taskReminderPlan(
      tasks,
      DateTime.now(),
      hour.value,
      minute.value,
      includeOverdue: true,
    );
    final pending = await device.pendingIds();
    for (final id in pending.where((id) => id > 0 && !plan.containsKey(id))) {
      await device.cancel(id);
    }
    for (final entry in plan.entries) {
      if (generation != _generation) return;
      await device.schedule(
        entry.key,
        entry.value,
        'Task reminder'.tr,
        'Open LifeSync to review your due task.'.tr,
      );
    }
    scheduledCount.value = plan.length;
  }

  Future<void> updateHabits(List<HabitModel> habits, List<HabitLogModel> logs) {
    _habitRevision++;
    final generation = _generation;
    return _serialize(() async {
      if (!_initialized || !enabled.value || generation != _generation) return;
      await _applyHabits(habits, logs, generation);
    });
  }

  Future<void> _applyHabits(
    List<HabitModel> habits,
    List<HabitLogModel> logs,
    int generation,
  ) async {
    final plan = habitReminderPlan(
      habits,
      logs,
      DateTime.now(),
      hour.value,
      minute.value,
    );
    for (final id in await device.pendingIds()) {
      if (generation != _generation) return;
      if (isHabitReminderId(id) && !plan.containsKey(id)) {
        await device.cancel(id);
      }
    }
    for (final entry in plan.entries) {
      if (generation != _generation) return;
      await device.schedule(
        entry.key,
        entry.value,
        'Habit reminder'.tr,
        'Open LifeSync to review your scheduled habits.'.tr,
      );
    }
    scheduledHabitCount.value = plan.length;
  }

  void _updatePolling() {
    _timer?.cancel();
    if (enabled.value &&
        session.isAuthenticated &&
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.paused) {
      _timer = Timer.periodic(const Duration(minutes: 1), (_) => refresh());
    }
  }

  @override
  void onClose() {
    _generation++;
    _timer?.cancel();
    session.onSessionChanged = null;
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
