import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';
import 'package:life_sync_app/features/home/presentation/pages/home_screen.dart';
import 'package:life_sync_app/features/user/data/models/user_profile_model.dart';
import 'package:life_sync_app/features/user/domain/repositories/user_repository.dart';
import 'package:life_sync_app/features/user/presentation/controllers/profile_controller.dart';
import 'package:life_sync_app/features/tasks/data/models/task_models.dart';
import 'package:life_sync_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:life_sync_app/features/tasks/presentation/controllers/task_controller.dart';
import 'package:life_sync_app/features/habits/data/models/habit_models.dart';
import 'package:life_sync_app/features/habits/domain/repositories/habit_repository.dart';
import 'package:life_sync_app/features/habits/presentation/controllers/habit_controller.dart';
import 'package:life_sync_app/features/notifications/data/models/notification_model.dart';
import 'package:life_sync_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:life_sync_app/features/notifications/presentation/controllers/notification_controller.dart';

void main() {
  tearDown(() => Get.reset());
  for (final width in [320.0, 393.0]) {
    testWidgets('long Google display name fits Home at $width', (tester) async {
      tester.view.physicalSize = Size(width, 850);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final session = AuthSessionService(_Storage());
      await session.saveSession(
        const StoredAuthSession(
          accessToken: 'test-only',
          tokenType: 'Bearer',
          userId: 1,
        ),
      );
      Get.put(ProfileController(_Users(), session, ImagePicker()));
      Get.put(TaskController(_Tasks()));
      Get.put(HabitController(_Habits()));
      Get.put(NotificationController(_Notifications()));
      final errors = <FlutterErrorDetails>[];
      final previousHandler = FlutterError.onError;
      FlutterError.onError = (details) {
        errors.add(details);
        previousHandler?.call(details);
      };
      await tester.pumpWidget(const GetMaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      FlutterError.onError = previousHandler;
      expect(tester.takeException(), isNull, reason: errors.join('\n'));
    });
  }
}

class _Storage implements TokenStorage {
  StoredAuthSession? session;
  @override
  Future<void> saveSession(StoredAuthSession value) async {
    session = value;
  }

  @override
  Future<StoredAuthSession?> readSession() async => session;
  @override
  Future<void> clearSession() async {
    session = null;
  }
}

class _Users implements UserRepository {
  @override
  Future<ApiResult<UserProfileModel>> getProfile(int userId) async =>
      ApiSuccess(
        UserProfileModel(
          id: 1,
          fullName:
              'A very long Google display name that must fit on a small phone',
          email: 'test@example.com',
          verified: true,
          createdAt: DateTime(2026),
        ),
      );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Tasks implements TaskRepository {
  @override
  Future<ApiResult<List<TaskModel>>> getTasks() async => const ApiSuccess([]);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Habits implements HabitRepository {
  @override
  Future<ApiResult<List<HabitModel>>> getHabits() async => const ApiSuccess([]);
  @override
  Future<ApiResult<List<HabitLogModel>>> getLogs() async =>
      const ApiSuccess([]);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Notifications implements NotificationRepository {
  @override
  Future<ApiResult<List<AppNotificationModel>>> getNotifications() async =>
      const ApiSuccess([]);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
