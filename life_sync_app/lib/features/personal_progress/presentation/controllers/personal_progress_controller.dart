import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/features/personal_progress/data/models/personal_progress_models.dart';
import 'package:life_sync_app/features/personal_progress/domain/repositories/personal_progress_repository.dart';

final class PersonalProgressController extends GetxController {
  PersonalProgressController(this._repository, this._sessionService);

  final PersonalProgressRepository _repository;
  final AuthSessionService _sessionService;

  final state = const AsyncViewState<PersonalProgressData>.initial().obs;
  final isSubmitting = false.obs;
  final errorMessage = RxnString();

  PersonalProgressData get data =>
      state.value.data ??
      const PersonalProgressData(
        checkings: [],
        reviews: [],
        wins: [],
        reward: null,
      );

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

    final results = await Future.wait([
      _repository.getCheckings(),
      _repository.getReviews(),
      _repository.getWins(),
      _repository.getRewards(),
    ]);
    final checkingResult = results[0] as ApiResult<List<MorningCheckingModel>>;
    final reviewResult = results[1] as ApiResult<List<WeeklyReviewModel>>;
    final winResult = results[2] as ApiResult<List<WinModel>>;
    final rewardResult = results[3] as ApiResult<List<UserRewardModel>>;

    ApiException? error;
    for (final candidate in [
      checkingResult.errorOrNull,
      reviewResult.errorOrNull,
      winResult.errorOrNull,
      rewardResult.errorOrNull,
    ]) {
      if (candidate != null) {
        error = candidate;
        break;
      }
    }
    if (error != null) {
      state.value = AsyncViewState.error(error, previousData: previous);
      return;
    }

    final rewards = rewardResult.dataOrNull!;
    final next = PersonalProgressData(
      checkings: checkingResult.dataOrNull!,
      reviews: reviewResult.dataOrNull!,
      wins: winResult.dataOrNull!,
      reward: rewards.isEmpty ? null : rewards.first,
    );
    state.value = next.isEmpty
        ? const AsyncViewState.empty()
        : AsyncViewState.success(next);
  }

  Future<bool> createChecking({required int moodRating, String? notes}) =>
      _mutate(
        () => _repository.createChecking(moodRating: moodRating, notes: notes),
        (item) => _setData(
          PersonalProgressData(
            checkings: [item, ...data.checkings],
            reviews: data.reviews,
            wins: data.wins,
            reward: data.reward,
          ),
        ),
      );

  Future<bool> updateChecking(
    MorningCheckingModel checking, {
    required int moodRating,
    String? notes,
  }) => _mutate(
    () => _repository.updateChecking(
      id: checking.id,
      moodRating: moodRating,
      notes: notes,
    ),
    (item) => _setData(
      PersonalProgressData(
        checkings: [
          for (final old in data.checkings)
            if (old.id == item.id) item else old,
        ],
        reviews: data.reviews,
        wins: data.wins,
        reward: data.reward,
      ),
    ),
  );

  Future<bool> deleteChecking(MorningCheckingModel checking) => _delete(
    () => _repository.deleteChecking(checking.id),
    () => _setData(
      PersonalProgressData(
        checkings: data.checkings
            .where((item) => item.id != checking.id)
            .toList(),
        reviews: data.reviews,
        wins: data.wins,
        reward: data.reward,
      ),
    ),
  );

  Future<bool> createReview({
    required String summary,
    required DateTime startDate,
    required DateTime endDate,
  }) => _mutate(
    () => _repository.createReview(
      summary: summary,
      startDate: startDate,
      endDate: endDate,
    ),
    (item) => _setData(
      PersonalProgressData(
        checkings: data.checkings,
        reviews: [item, ...data.reviews],
        wins: data.wins,
        reward: data.reward,
      ),
    ),
  );

  Future<bool> updateReview(
    WeeklyReviewModel review, {
    required String summary,
    required DateTime startDate,
    required DateTime endDate,
  }) => _mutate(
    () => _repository.updateReview(
      id: review.id,
      summary: summary,
      startDate: startDate,
      endDate: endDate,
    ),
    (item) => _setData(
      PersonalProgressData(
        checkings: data.checkings,
        reviews: [
          for (final old in data.reviews)
            if (old.id == item.id) item else old,
        ],
        wins: data.wins,
        reward: data.reward,
      ),
    ),
  );

  Future<bool> deleteReview(WeeklyReviewModel review) => _delete(
    () => _repository.deleteReview(review.id),
    () => _setData(
      PersonalProgressData(
        checkings: data.checkings,
        reviews: data.reviews.where((item) => item.id != review.id).toList(),
        wins: data.wins,
        reward: data.reward,
      ),
    ),
  );

  Future<bool> createWin({required String title, String? description}) =>
      _mutate(
        () => _repository.createWin(title: title, description: description),
        (item) => _setData(
          PersonalProgressData(
            checkings: data.checkings,
            reviews: data.reviews,
            wins: [item, ...data.wins],
            reward: data.reward,
          ),
        ),
      );

  Future<bool> updateWin(
    WinModel win, {
    required String title,
    String? description,
  }) => _mutate(
    () => _repository.updateWin(
      id: win.id,
      title: title,
      description: description,
    ),
    (item) => _setData(
      PersonalProgressData(
        checkings: data.checkings,
        reviews: data.reviews,
        wins: [
          for (final old in data.wins)
            if (old.id == item.id) item else old,
        ],
        reward: data.reward,
      ),
    ),
  );

  Future<bool> deleteWin(WinModel win) => _delete(
    () => _repository.deleteWin(win.id),
    () => _setData(
      PersonalProgressData(
        checkings: data.checkings,
        reviews: data.reviews,
        wins: data.wins.where((item) => item.id != win.id).toList(),
        reward: data.reward,
      ),
    ),
  );

  Future<bool> addPoints(int points) => _changePoints(points, subtract: false);

  Future<bool> subtractPoints(int points) =>
      _changePoints(points, subtract: true);

  Future<bool> resetReward() {
    final reward = data.reward;
    if (reward == null) return Future.value(true);
    return _delete(
      () => _repository.deleteReward(reward.id),
      () => _setData(
        PersonalProgressData(
          checkings: data.checkings,
          reviews: data.reviews,
          wins: data.wins,
          reward: null,
        ),
      ),
    );
  }

  Future<bool> _changePoints(int points, {required bool subtract}) async {
    final userId = _sessionService.currentSession?.userId;
    if (userId == null) {
      await _sessionService.handleUnauthorized();
      return false;
    }
    return _mutate(
      () => subtract
          ? _repository.subtractPoints(userId, points)
          : _repository.addPoints(userId, points),
      (reward) => _setData(
        PersonalProgressData(
          checkings: data.checkings,
          reviews: data.reviews,
          wins: data.wins,
          reward: reward,
        ),
      ),
    );
  }

  Future<bool> _mutate<T>(
    Future<ApiResult<T>> Function() operation,
    void Function(T) update,
  ) async {
    if (!_begin()) return false;
    try {
      return (await operation()).when(
        success: (item) {
          update(item);
          return true;
        },
        failure: _failure,
      );
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
      return (await operation()).when(
        success: (_) {
          update();
          return true;
        },
        failure: _failure,
      );
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

  void _setData(PersonalProgressData value) {
    state.value = value.isEmpty
        ? const AsyncViewState.empty()
        : AsyncViewState.success(value);
  }
}
