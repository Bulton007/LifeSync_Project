import 'package:life_sync_app/core/utils/api_date_codec.dart';

final class MorningCheckingModel {
  const MorningCheckingModel({
    required this.id,
    required this.userId,
    required this.moodRating,
    required this.checkedInAt,
    this.notes,
  });

  factory MorningCheckingModel.fromJson(Map<String, dynamic> json) =>
      MorningCheckingModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        userId: (json['userId'] as num?)?.toInt() ?? 0,
        moodRating: (json['moodRating'] as num?)?.toInt() ?? 5,
        notes: json['notes'] as String?,
        checkedInAt: ApiDateCodec.decodeLocalDateTime(json['checkedInAt']),
      );

  final int id;
  final int userId;
  final int moodRating;
  final String? notes;
  final DateTime checkedInAt;
}

final class WeeklyReviewModel {
  const WeeklyReviewModel({
    required this.id,
    required this.userId,
    required this.reviewSummary,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  factory WeeklyReviewModel.fromJson(Map<String, dynamic> json) =>
      WeeklyReviewModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        userId: (json['userId'] as num?)?.toInt() ?? 0,
        reviewSummary: (json['reviewSummary'] ?? '') as String,
        startDate: ApiDateCodec.decodeLocalDateTime(json['startDate']),
        endDate: ApiDateCodec.decodeLocalDateTime(json['endDate']),
        createdAt: ApiDateCodec.decodeLocalDateTime(json['createdAt']),
      );

  final int id;
  final int userId;
  final String reviewSummary;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
}

final class WinModel {
  const WinModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    this.description,
  });

  factory WinModel.fromJson(Map<String, dynamic> json) => WinModel(
    id: (json['id'] as num?)?.toInt() ?? 0,
    userId: (json['userId'] as num?)?.toInt() ?? 0,
    title: (json['title'] ?? '') as String,
    description: json['description'] as String?,
    createdAt: ApiDateCodec.decodeLocalDateTime(json['createdAt']),
  );

  final int id;
  final int userId;
  final String title;
  final String? description;
  final DateTime createdAt;
}

final class UserRewardModel {
  const UserRewardModel({
    required this.id,
    required this.userId,
    required this.points,
    required this.level,
    required this.updatedAt,
  });

  factory UserRewardModel.fromJson(Map<String, dynamic> json) =>
      UserRewardModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        userId: (json['userId'] as num?)?.toInt() ?? 0,
        points: (json['points'] as num?)?.toInt() ?? 0,
        level: (json['level'] as num?)?.toInt() ?? 1,
        updatedAt: ApiDateCodec.decodeLocalDateTime(json['updatedAt']),
      );

  final int id;
  final int userId;
  final int points;
  final int level;
  final DateTime updatedAt;
  int get pointsIntoLevel => points % 100;
  double get levelProgress => pointsIntoLevel / 100;
}

final class PersonalProgressData {
  const PersonalProgressData({
    required this.checkings,
    required this.reviews,
    required this.wins,
    required this.reward,
  });

  final List<MorningCheckingModel> checkings;
  final List<WeeklyReviewModel> reviews;
  final List<WinModel> wins;
  final UserRewardModel? reward;

  bool get isEmpty =>
      checkings.isEmpty && reviews.isEmpty && wins.isEmpty && reward == null;

  double? get averageMood {
    if (checkings.isEmpty) return null;
    return checkings.fold<int>(0, (sum, item) => sum + item.moodRating) /
        checkings.length;
  }
}
