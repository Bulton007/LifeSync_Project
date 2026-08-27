import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/personal_progress/data/datasources/personal_progress_remote_data_source.dart';
import 'package:life_sync_app/features/personal_progress/data/models/personal_progress_models.dart';
import 'package:life_sync_app/features/personal_progress/domain/repositories/personal_progress_repository.dart';

final class PersonalProgressRepositoryImpl
    implements PersonalProgressRepository {
  const PersonalProgressRepositoryImpl(this._remote);

  final PersonalProgressRemoteDataSource _remote;

  @override
  Future<ApiResult<List<MorningCheckingModel>>> getCheckings() =>
      _remote.getCheckings();
  @override
  Future<ApiResult<MorningCheckingModel>> createChecking({
    required int moodRating,
    String? notes,
  }) => _remote.createChecking(moodRating: moodRating, notes: notes);
  @override
  Future<ApiResult<MorningCheckingModel>> updateChecking({
    required int id,
    required int moodRating,
    String? notes,
  }) => _remote.updateChecking(id: id, moodRating: moodRating, notes: notes);
  @override
  Future<ApiResult<void>> deleteChecking(int id) => _remote.deleteChecking(id);

  @override
  Future<ApiResult<List<WeeklyReviewModel>>> getReviews() =>
      _remote.getReviews();
  @override
  Future<ApiResult<WeeklyReviewModel>> createReview({
    required String summary,
    required DateTime startDate,
    required DateTime endDate,
  }) => _remote.createReview(
    summary: summary,
    startDate: startDate,
    endDate: endDate,
  );
  @override
  Future<ApiResult<WeeklyReviewModel>> updateReview({
    required int id,
    required String summary,
    required DateTime startDate,
    required DateTime endDate,
  }) => _remote.updateReview(
    id: id,
    summary: summary,
    startDate: startDate,
    endDate: endDate,
  );
  @override
  Future<ApiResult<void>> deleteReview(int id) => _remote.deleteReview(id);

  @override
  Future<ApiResult<List<WinModel>>> getWins() => _remote.getWins();
  @override
  Future<ApiResult<WinModel>> createWin({
    required String title,
    String? description,
  }) => _remote.createWin(title: title, description: description);
  @override
  Future<ApiResult<WinModel>> updateWin({
    required int id,
    required String title,
    String? description,
  }) => _remote.updateWin(id: id, title: title, description: description);
  @override
  Future<ApiResult<void>> deleteWin(int id) => _remote.deleteWin(id);

  @override
  Future<ApiResult<List<UserRewardModel>>> getRewards() => _remote.getRewards();
  @override
  Future<ApiResult<UserRewardModel>> addPoints(int userId, int points) =>
      _remote.addPoints(userId, points);
  @override
  Future<ApiResult<UserRewardModel>> subtractPoints(int userId, int points) =>
      _remote.subtractPoints(userId, points);
  @override
  Future<ApiResult<void>> deleteReward(int id) => _remote.deleteReward(id);
}
