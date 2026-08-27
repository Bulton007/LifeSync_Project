import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/utils/api_date_codec.dart';
import 'package:life_sync_app/features/personal_progress/data/models/personal_progress_models.dart';

final class PersonalProgressRemoteDataSource {
  const PersonalProgressRemoteDataSource(this._api);

  final ApiClient _api;

  Future<ApiResult<List<MorningCheckingModel>>> getCheckings() => _api.get(
    '/api/morning-checkings',
    decoder: (data) => _list(data, MorningCheckingModel.fromJson),
  );

  Future<ApiResult<MorningCheckingModel>> createChecking({
    required int moodRating,
    String? notes,
  }) => _api.post(
    '/api/morning-checkings',
    data: {'moodRating': moodRating, 'notes': _optional(notes)},
    decoder: _checking,
  );

  Future<ApiResult<MorningCheckingModel>> updateChecking({
    required int id,
    required int moodRating,
    String? notes,
  }) => _api.put(
    '/api/morning-checkings/$id',
    data: {'moodRating': moodRating, 'notes': _optional(notes)},
    decoder: _checking,
  );

  Future<ApiResult<void>> deleteChecking(int id) =>
      _api.delete('/api/morning-checkings/$id', decoder: (_) {});

  Future<ApiResult<List<WeeklyReviewModel>>> getReviews() => _api.get(
    '/api/weekly-reviews',
    decoder: (data) => _list(data, WeeklyReviewModel.fromJson),
  );

  Future<ApiResult<WeeklyReviewModel>> createReview({
    required String summary,
    required DateTime startDate,
    required DateTime endDate,
  }) => _api.post(
    '/api/weekly-reviews',
    data: _reviewBody(summary, startDate, endDate),
    decoder: _review,
  );

  Future<ApiResult<WeeklyReviewModel>> updateReview({
    required int id,
    required String summary,
    required DateTime startDate,
    required DateTime endDate,
  }) => _api.put(
    '/api/weekly-reviews/$id',
    data: _reviewBody(summary, startDate, endDate),
    decoder: _review,
  );

  Future<ApiResult<void>> deleteReview(int id) =>
      _api.delete('/api/weekly-reviews/$id', decoder: (_) {});

  Future<ApiResult<List<WinModel>>> getWins() =>
      _api.get('/api/wins', decoder: (data) => _list(data, WinModel.fromJson));

  Future<ApiResult<WinModel>> createWin({
    required String title,
    String? description,
  }) => _api.post(
    '/api/wins',
    data: {'title': title.trim(), 'description': _optional(description)},
    decoder: _win,
  );

  Future<ApiResult<WinModel>> updateWin({
    required int id,
    required String title,
    String? description,
  }) => _api.put(
    '/api/wins/$id',
    data: {'title': title.trim(), 'description': _optional(description)},
    decoder: _win,
  );

  Future<ApiResult<void>> deleteWin(int id) =>
      _api.delete('/api/wins/$id', decoder: (_) {});

  Future<ApiResult<List<UserRewardModel>>> getRewards() => _api.get(
    '/api/user-rewards',
    decoder: (data) => _list(data, UserRewardModel.fromJson),
  );

  Future<ApiResult<UserRewardModel>> addPoints(int userId, int points) =>
      _api.patch(
        '/api/user-rewards/users/$userId/add-points',
        data: {'points': points},
        decoder: _reward,
      );

  Future<ApiResult<UserRewardModel>> subtractPoints(int userId, int points) =>
      _api.patch(
        '/api/user-rewards/users/$userId/subtract-points',
        data: {'points': points},
        decoder: _reward,
      );

  Future<ApiResult<void>> deleteReward(int id) =>
      _api.delete('/api/user-rewards/$id', decoder: (_) {});

  static Map<String, dynamic> _reviewBody(
    String summary,
    DateTime startDate,
    DateTime endDate,
  ) => {
    'reviewSummary': summary.trim(),
    'startDate': ApiDateCodec.encodeLocalDateTime(startDate),
    'endDate': ApiDateCodec.encodeLocalDateTime(endDate),
  };

  static String? _optional(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  static MorningCheckingModel _checking(Object? data) =>
      MorningCheckingModel.fromJson(Map<String, dynamic>.from(data! as Map));
  static WeeklyReviewModel _review(Object? data) =>
      WeeklyReviewModel.fromJson(Map<String, dynamic>.from(data! as Map));
  static WinModel _win(Object? data) =>
      WinModel.fromJson(Map<String, dynamic>.from(data! as Map));
  static UserRewardModel _reward(Object? data) =>
      UserRewardModel.fromJson(Map<String, dynamic>.from(data! as Map));
  static List<T> _list<T>(
    Object? data,
    T Function(Map<String, dynamic>) decoder,
  ) => (data! as List)
      .map((item) => decoder(Map<String, dynamic>.from(item as Map)))
      .toList(growable: false);
}
