import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/features/notifications/data/models/notification_model.dart';

void main() {
  test('notification model matches backend ownership and history fields', () {
    final notification = AppNotificationModel.fromJson({
      'notificationId': 12,
      'userId': 4,
      'title': 'Morning reminder',
      'message': 'Complete your check-in',
      'type': 'REMINDER',
      'isRead': false,
      'createdAt': '2026-08-27T07:00:00',
    });

    expect(notification.notificationId, 12);
    expect(notification.userId, 4);
    expect(notification.type, 'REMINDER');
    expect(notification.isRead, isFalse);
    expect(notification.createdAt.hour, 7);
  });

  test('copyWith changes read state without losing response data', () {
    final notification = AppNotificationModel.fromJson({
      'notificationId': 12,
      'userId': 4,
      'title': 'Weekly review',
      'message': 'Reflect on this week',
      'isRead': false,
      'createdAt': '2026-08-27T07:00:00',
    });

    final read = notification.copyWith(isRead: true);
    expect(read.isRead, isTrue);
    expect(read.title, notification.title);
    expect(read.userId, notification.userId);
  });
}
