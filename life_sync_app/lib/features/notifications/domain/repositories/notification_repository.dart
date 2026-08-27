import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/notifications/data/models/notification_model.dart';

abstract interface class NotificationRepository {
  Future<ApiResult<List<AppNotificationModel>>> getNotifications();
  Future<ApiResult<AppNotificationModel>> markAsRead(int id);
  Future<ApiResult<void>> markAllAsRead();
  Future<ApiResult<void>> deleteNotification(int id);
}
