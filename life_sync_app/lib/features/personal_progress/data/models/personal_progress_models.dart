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
        id: (json['id'] as num).toInt(),
        userId: (json['userId'] as num).toInt(),
        moodRating: (json['moodRating'] as num).toInt(),
        notes: json['notes'] as String?,
        checkedInAt: ApiDateCodec.decodeLocalDateTime(
          json['checkedInAt'] as String,
        ),
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

  factory WeeklyReviewModel.fromJson(
    Map<String, dynamic> json,
  ) => WeeklyReviewModel(
    id: (json['id'] as num).toInt(),
    userId: (json['userId'] as num).toInt(),
    reviewSummary: json['reviewSummary'] as String,
    startDate: ApiDateCodec.decodeLocalDateTime(json['startDate'] as String),
    endDate: ApiDateCodec.decodeLocalDateTime(json['endDate'] as String),
    createdAt: ApiDateCodec.decodeLocalDateTime(json['createdAt'] as String),
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
    id: (json['id'] as num).toInt(),
    userId: (json['userId'] as num).toInt(),
    title: json['title'] as String,
    description: json['description'] as String?,
    createdAt: ApiDateCodec.decodeLocalDateTime(json['createdAt'] as String),
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
        id: (json['id'] as num).toInt(),
        userId: (json['userId'] as num).toInt(),
        points: (json['points'] as num).toInt(),
        level: (json['level'] as num).toInt(),
        updatedAt: ApiDateCodec.decodeLocalDateTime(
          json['updatedAt'] as String,
        ),
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
