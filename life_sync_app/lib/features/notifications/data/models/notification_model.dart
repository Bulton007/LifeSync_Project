import 'package:life_sync_app/core/utils/api_date_codec.dart';

final class AppNotificationModel {
  const AppNotificationModel({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.type,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) =>
      AppNotificationModel(
        notificationId: (json['notificationId'] as num).toInt(),
        userId: (json['userId'] as num).toInt(),
        title: json['title'] as String,
        message: json['message'] as String,
        type: json['type'] as String?,
        isRead: json['isRead'] as bool? ?? false,
        createdAt: ApiDateCodec.decodeLocalDateTime(
          json['createdAt'] as String,
        ),
      );

  final int notificationId;
  final int userId;
  final String title;
  final String message;
  final String? type;
  final bool isRead;
  final DateTime createdAt;

  AppNotificationModel copyWith({bool? isRead}) => AppNotificationModel(
    notificationId: notificationId,
    userId: userId,
    title: title,
    message: message,
    type: type,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt,
  );
}
