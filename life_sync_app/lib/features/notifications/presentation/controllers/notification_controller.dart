import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/features/notifications/data/models/notification_model.dart';
import 'package:life_sync_app/features/notifications/domain/repositories/notification_repository.dart';

enum NotificationFilter { all, unread }

final class NotificationController extends GetxController {
  NotificationController(this._repository);

  final NotificationRepository _repository;

  final state = const AsyncViewState<List<AppNotificationModel>>.initial().obs;
  final filter = NotificationFilter.all.obs;
  final isSubmitting = false.obs;
  final errorMessage = RxnString();

  List<AppNotificationModel> get notifications => state.value.data ?? const [];
  List<AppNotificationModel> get visibleNotifications =>
      filter.value == NotificationFilter.all
      ? notifications
      : notifications.where((item) => !item.isRead).toList(growable: false);
  int get unreadCount => notifications.where((item) => !item.isRead).length;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool refresh = false}) async {
    final previous = state.value.data;
    state.value = refresh && previous != null
        ? AsyncViewState.refreshing(previous)
        : const AsyncViewState.loading();
    final result = await _repository.getNotifications();
    result.when(
      success: (items) => state.value = items.isEmpty
          ? const AsyncViewState.empty()
          : AsyncViewState.success(items),
      failure: (exception) =>
          state.value = AsyncViewState.error(exception, previousData: previous),
    );
  }

  Future<bool> markAsRead(AppNotificationModel notification) async {
    if (notification.isRead) return true;
    return _mutate(
      () => _repository.markAsRead(notification.notificationId),
      (updated) => _setItems([
        for (final old in notifications)
          if (old.notificationId == updated.notificationId) updated else old,
      ]),
    );
  }

  Future<bool> markAllAsRead() => _delete(
    _repository.markAllAsRead,
    () => _setItems([
      for (final item in notifications) item.copyWith(isRead: true),
    ]),
  );

  Future<bool> deleteNotification(AppNotificationModel notification) => _delete(
    () => _repository.deleteNotification(notification.notificationId),
    () => _setItems(
      notifications
          .where((item) => item.notificationId != notification.notificationId)
          .toList(),
    ),
  );

  Future<bool> _mutate<T>(
    Future<ApiResult<T>> Function() operation,
    void Function(T) update,
  ) async {
    if (!_begin()) return false;
    try {
      final result = (await operation()).when<bool>(
        success: (item) {
          update(item);
          return true;
        },
        failure: _failure,
      );
      return result;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> _delete(
    Future<ApiResult<void>> Function() operation,
    void Function() update,
  ) async {
    if (!_begin()) return false;
    try {
      final result = (await operation()).when<bool>(
        success: (_) {
          update();
          return true;
        },
        failure: _failure,
      );
      return result;
    } finally {
      isSubmitting.value = false;
    }
  }

  bool _begin() {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    return true;
  }

  bool _failure(ApiException exception) {
    errorMessage.value = exception.message;
    return false;
  }

  void _setItems(List<AppNotificationModel> items) {
    state.value = items.isEmpty
        ? const AsyncViewState.empty()
        : AsyncViewState.success(items);
  }
}
