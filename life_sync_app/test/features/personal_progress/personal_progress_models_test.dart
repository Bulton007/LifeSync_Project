import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/features/personal_progress/data/models/personal_progress_models.dart';

void main() {
  test('personal progress models match Spring response fields', () {
    final checking = MorningCheckingModel.fromJson({
      'id': 1,
      'userId': 7,
      'moodRating': 8,
      'notes': 'Ready',
      'checkedInAt': '2026-08-27T07:30:00',
    });
    final review = WeeklyReviewModel.fromJson({
      'id': 2,
      'userId': 7,
      'reviewSummary': 'A focused week',
      'startDate': '2026-08-17T00:00:00',
      'endDate': '2026-08-23T23:59:59',
      'createdAt': '2026-08-24T08:00:00',
    });
    final win = WinModel.fromJson({
      'id': 3,
      'userId': 7,
      'title': 'Shipped Batch 6',
      'description': 'Ownership protected',
      'createdAt': '2026-08-27T09:00:00',
    });

    expect(checking.moodRating, 8);
    expect(review.startDate.day, 17);
    expect(review.endDate.hour, 23);
    expect(win.userId, 7);
  });

  test('reward exposes deterministic level progress', () {
    final reward = UserRewardModel.fromJson({
      'id': 4,
      'userId': 7,
      'points': 225,
      'level': 3,
      'updatedAt': '2026-08-27T09:00:00',
    });

    expect(reward.pointsIntoLevel, 25);
    expect(reward.levelProgress, 0.25);
  });

  test('progress summary calculates mood history without sample values', () {
    final first = MorningCheckingModel.fromJson({
      'id': 1,
      'userId': 7,
      'moodRating': 6,
      'checkedInAt': '2026-08-26T07:30:00',
    });
    final second = MorningCheckingModel.fromJson({
      'id': 2,
      'userId': 7,
      'moodRating': 8,
      'checkedInAt': '2026-08-27T07:30:00',
    });
    final data = PersonalProgressData(
      checkings: [first, second],
      reviews: const [],
      wins: const [],
      reward: null,
    );

    expect(data.averageMood, 7);
    expect(data.isEmpty, isFalse);
  });
}
