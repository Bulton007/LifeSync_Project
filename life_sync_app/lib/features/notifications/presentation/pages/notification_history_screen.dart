import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/core/widgets/app_error_view.dart';
import 'package:life_sync_app/core/widgets/app_loading_view.dart';
import 'package:life_sync_app/features/notifications/data/models/notification_model.dart';
import 'package:life_sync_app/features/notifications/presentation/controllers/notification_controller.dart';

final class NotificationHistoryScreen extends StatelessWidget {
  const NotificationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Obx(
            () => TextButton(
              onPressed:
                  controller.unreadCount == 0 || controller.isSubmitting.value
                  ? null
                  : () => _markAll(context, controller),
              child: const Text('Read all'),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final state = controller.state.value;
        if (state.status == ViewStatus.initial ||
            state.status == ViewStatus.loading) {
          return const AppLoadingView(message: 'Loading notifications…');
        }
        if (state.status == ViewStatus.error && state.data == null) {
          return AppErrorView(
            message:
                state.exception?.message ??
                'Notifications could not be loaded.',
            onRetry: controller.load,
          );
        }
        final visible = controller.visibleNotifications;
        return RefreshIndicator(
          onRefresh: () => controller.load(refresh: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
            children: [
              if (state.status == ViewStatus.error && state.exception != null)
                _InlineError(message: state.exception!.message),
              Row(
                children: [
                  ChoiceChip(
                    label: Text('All (${controller.notifications.length})'),
                    selected: controller.filter.value == NotificationFilter.all,
                    onSelected: (_) =>
                        controller.filter.value = NotificationFilter.all,
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('Unread (${controller.unreadCount})'),
                    selected:
                        controller.filter.value == NotificationFilter.unread,
                    onSelected: (_) =>
                        controller.filter.value = NotificationFilter.unread,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (visible.isEmpty)
                _NotificationEmpty(
                  unreadOnly:
                      controller.filter.value == NotificationFilter.unread,
                )
              else
                ...visible.map(
                  (notification) => _NotificationCard(
                    notification: notification,
                    controller: controller,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

final class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.controller,
  });

  final AppNotificationModel notification;
  final NotificationController controller;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    color: notification.isRead ? Colors.white : const Color(0xFFEAF5FF),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: notification.isRead
          ? null
          : () async {
              final saved = await controller.markAsRead(notification);
              if (!saved && context.mounted) {
                _showError(context, controller);
              }
            },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 6, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: notification.isRead
                  ? Colors.grey.shade100
                  : Colors.white,
              child: Icon(
                _typeIcon(notification.type),
                color: notification.isRead
                    ? Colors.grey
                    : const Color(0xFF1E88E5),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: Color(0xFF1E88E5),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notification.message,
                    style: const TextStyle(color: Colors.black54, height: 1.35),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _dateTime(notification.createdAt),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'read') {
                  controller.markAsRead(notification).then((saved) {
                    if (!saved && context.mounted) {
                      _showError(context, controller);
                    }
                  });
                } else {
                  _delete(context, controller, notification);
                }
              },
              itemBuilder: (_) => [
                if (!notification.isRead)
                  const PopupMenuItem(
                    value: 'read',
                    child: Text('Mark as read'),
                  ),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

final class _NotificationEmpty extends StatelessWidget {
  const _NotificationEmpty({required this.unreadOnly});

  final bool unreadOnly;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      children: [
        Icon(
          unreadOnly
              ? Icons.mark_email_read_outlined
              : Icons.notifications_none_rounded,
          size: 50,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 12),
        Text(
          unreadOnly ? 'You are all caught up' : 'No notification history yet',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          unreadOnly
              ? 'There are no unread notifications.'
              : 'New LifeSync updates will appear here.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

final class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.red.shade50,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(message, style: TextStyle(color: Colors.red.shade800)),
  );
}

Future<void> _markAll(
  BuildContext context,
  NotificationController controller,
) async {
  final saved = await controller.markAllAsRead();
  if (!saved && context.mounted) _showError(context, controller);
}

Future<void> _delete(
  BuildContext context,
  NotificationController controller,
  AppNotificationModel notification,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete notification?'),
      content: const Text('This removes it from your notification history.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  final saved = await controller.deleteNotification(notification);
  if (!saved && context.mounted) _showError(context, controller);
}

void _showError(BuildContext context, NotificationController controller) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        controller.errorMessage.value ?? 'Notification could not be updated.',
      ),
    ),
  );
}

IconData _typeIcon(String? type) => switch (type?.toUpperCase()) {
  'REMINDER' => Icons.alarm_outlined,
  'PROGRESS' => Icons.insights_outlined,
  'FINANCE' => Icons.account_balance_wallet_outlined,
  'GOAL' => Icons.flag_outlined,
  _ => Icons.notifications_outlined,
};

String _dateTime(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/'
    '${value.month.toString().padLeft(2, '0')}/${value.year} '
    '${value.hour.toString().padLeft(2, '0')}:'
    '${value.minute.toString().padLeft(2, '0')}';
