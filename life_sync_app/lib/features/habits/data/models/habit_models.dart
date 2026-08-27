import 'package:life_sync_app/core/utils/api_date_codec.dart';

final class HabitModel {
  const HabitModel({
    required this.habitId,
    required this.userId,
    required this.name,
    required this.frequency,
    required this.streak,
    required this.active,
    this.description,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) => HabitModel(
    habitId: (json['habitId'] as num).toInt(),
    userId: (json['userId'] as num).toInt(),
    name: json['name'] as String,
    description: json['description'] as String?,
    frequency: json['frequency'] as String,
    streak: (json['streak'] as num?)?.toInt() ?? 0,
    active: json['active'] as bool? ?? true,
    startDate: _date(json['startDate']),
    endDate: _date(json['endDate']),
    createdAt: _dateTime(json['createdAt']),
    updatedAt: _dateTime(json['updatedAt']),
  );

  final int habitId;
  final int userId;
  final String name;
  final String? description;
  final String frequency;
  final int streak;
  final bool active;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get frequencyKind => frequency.split(':').first.toUpperCase();

  List<String> get scheduledDays {
    final parts = frequency.split(':');
    return parts.length < 2 || parts[1].isEmpty
        ? const []
        : parts[1].split(',');
  }

  bool isScheduledFor(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    if (startDate != null && day.isBefore(startDate!)) return false;
    if (endDate != null && day.isAfter(endDate!)) return false;
    if (frequencyKind == 'DAILY') return true;
    if (frequencyKind == 'MONTHLY') {
      return startDate == null || day.day == startDate!.day;
    }
    if (frequencyKind == 'WEEKLY' || frequencyKind == 'WEEKDAYS') {
      final days = scheduledDays;
      if (days.isEmpty) return frequencyKind == 'WEEKDAYS' && date.weekday <= 5;
      return days.contains(_weekdayCode(date.weekday));
    }
    return true;
  }

  static DateTime? _date(Object? value) =>
      value == null ? null : ApiDateCodec.decodeDate(value as String);

  static DateTime? _dateTime(Object? value) =>
      value == null ? null : ApiDateCodec.decodeLocalDateTime(value as String);

  static String _weekdayCode(int weekday) => const {
    DateTime.monday: 'MON',
    DateTime.tuesday: 'TUE',
    DateTime.wednesday: 'WED',
    DateTime.thursday: 'THU',
    DateTime.friday: 'FRI',
    DateTime.saturday: 'SAT',
    DateTime.sunday: 'SUN',
  }[weekday]!;
}

final class HabitLogModel {
  const HabitLogModel({
    required this.habitLogId,
    required this.habitId,
    required this.userId,
    required this.completedDate,
    required this.completed,
    required this.note,
    this.createdAt,
    this.updatedAt,
  });

  factory HabitLogModel.fromJson(Map<String, dynamic> json) => HabitLogModel(
    habitLogId: (json['habitLogId'] as num).toInt(),
    habitId: (json['habitId'] as num).toInt(),
    userId: (json['userId'] as num).toInt(),
    completedDate: ApiDateCodec.decodeDate(json['completedDate'] as String),
    completed: json['completed'] as bool? ?? true,
    note: json['note'] as String? ?? '',
    createdAt: json['createdAt'] == null
        ? null
        : ApiDateCodec.decodeLocalDateTime(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : ApiDateCodec.decodeLocalDateTime(json['updatedAt'] as String),
  );

  final int habitLogId;
  final int habitId;
  final int userId;
  final DateTime completedDate;
  final bool completed;
  final String note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
