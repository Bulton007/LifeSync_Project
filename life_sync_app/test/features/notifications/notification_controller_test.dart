import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/notifications/data/models/notification_model.dart';
import 'package:life_sync_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:life_sync_app/features/notifications/presentation/controllers/notification_controller.dart';

void main() {
  test(
    'notification history loads, filters, marks read, and deletes',
    () async {
      final controller = NotificationController(_Repository());
      await controller.load();
      expect(controller.unreadCount, 2);
      controller.filter.value = NotificationFilter.unread;
      expect(
        await controller.markAsRead(controller.notifications.first),
        isTrue,
      );
      expect(controller.visibleNotifications, hasLength(1));
      expect(await controller.markAllAsRead(), isTrue);
      expect(controller.unreadCount, 0);
      expect(controller.visibleNotifications, isEmpty);
      expect(
        await controller.deleteNotification(controller.notifications.first),
        isTrue,
      );
      expect(controller.notifications, hasLength(1));
    },
  );
}

class _Repository implements NotificationRepository {
  final items = List.generate(
    2,
    (index) => AppNotificationModel(
      notificationId: index + 1,
      userId: 1,
      title: 'Test',
      message: 'Reminder',
      isRead: false,
      createdAt: DateTime(2026, 1, 1),
    ),
  );
  @override
  Future<ApiResult<List<AppNotificationModel>>> getNotifications() async =>
      ApiSuccess([...items]);
  @override
  Future<ApiResult<AppNotificationModel>> markAsRead(int id) async {
    final index = items.indexWhere((item) => item.notificationId == id);
    items[index] = items[index].copyWith(isRead: true);
    return ApiSuccess(items[index]);
  }

  @override
  Future<ApiResult<void>> markAllAsRead() async {
    for (var index = 0; index < items.length; index++) {
      items[index] = items[index].copyWith(isRead: true);
    }
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<void>> deleteNotification(int id) async {
    items.removeWhere((item) => item.notificationId == id);
    return const ApiSuccess(null);
  }
}
