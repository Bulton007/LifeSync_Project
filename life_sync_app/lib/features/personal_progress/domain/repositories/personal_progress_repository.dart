import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/personal_progress/data/models/personal_progress_models.dart';

abstract interface class PersonalProgressRepository {
  Future<ApiResult<List<MorningCheckingModel>>> getCheckings();
  Future<ApiResult<MorningCheckingModel>> createChecking({
    required int moodRating,
    String? notes,
  });
  Future<ApiResult<MorningCheckingModel>> updateChecking({
    required int id,
    required int moodRating,
    String? notes,
  });
  Future<ApiResult<void>> deleteChecking(int id);

  Future<ApiResult<List<WeeklyReviewModel>>> getReviews();
  Future<ApiResult<WeeklyReviewModel>> createReview({
    required String summary,
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<ApiResult<WeeklyReviewModel>> updateReview({
    required int id,
    required String summary,
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<ApiResult<void>> deleteReview(int id);

  Future<ApiResult<List<WinModel>>> getWins();
  Future<ApiResult<WinModel>> createWin({
    required String title,
    String? description,
  });
  Future<ApiResult<WinModel>> updateWin({
    required int id,
    required String title,
    String? description,
  });
  Future<ApiResult<void>> deleteWin(int id);

  Future<ApiResult<List<UserRewardModel>>> getRewards();
  Future<ApiResult<UserRewardModel>> addPoints(int userId, int points);
  Future<ApiResult<UserRewardModel>> subtractPoints(int userId, int points);
  Future<ApiResult<void>> deleteReward(int id);
}
