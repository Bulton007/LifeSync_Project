import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/notifications/data/models/notification_model.dart';

final class NotificationRemoteDataSource {
  const NotificationRemoteDataSource(this._api);

  final ApiClient _api;

  Future<ApiResult<List<AppNotificationModel>>> getNotifications() => _api.get(
    '/api/notifications',
    decoder: (data) => (data! as List)
        .map(
          (item) => AppNotificationModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList(growable: false),
  );

  Future<ApiResult<AppNotificationModel>> markAsRead(int id) => _api.patch(
    '/api/notifications/$id/read',
    decoder: (data) =>
        AppNotificationModel.fromJson(Map<String, dynamic>.from(data! as Map)),
  );

  Future<ApiResult<void>> markAllAsRead() =>
      _api.patch('/api/notifications/read-all', decoder: (_) {});

  Future<ApiResult<void>> deleteNotification(int id) =>
      _api.delete('/api/notifications/$id', decoder: (_) {});
}
