import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:life_sync_app/features/notifications/data/models/notification_model.dart';
import 'package:life_sync_app/features/notifications/domain/repositories/notification_repository.dart';

final class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._remote);

  final NotificationRemoteDataSource _remote;

  @override
  Future<ApiResult<List<AppNotificationModel>>> getNotifications() =>
      _remote.getNotifications();
  @override
  Future<ApiResult<AppNotificationModel>> markAsRead(int id) =>
      _remote.markAsRead(id);
  @override
  Future<ApiResult<void>> markAllAsRead() => _remote.markAllAsRead();
  @override
  Future<ApiResult<void>> deleteNotification(int id) =>
      _remote.deleteNotification(id);
}
