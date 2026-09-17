import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';
import 'package:life_sync_app/features/personal_progress/data/models/personal_progress_models.dart';
import 'package:life_sync_app/features/personal_progress/domain/repositories/personal_progress_repository.dart';
import 'package:life_sync_app/features/personal_progress/presentation/controllers/personal_progress_controller.dart';

final class _FakeTokenStorage implements TokenStorage {
  StoredAuthSession? session;

  @override
  Future<void> clearSession() async => session = null;

  @override
  Future<StoredAuthSession?> readSession() async => session;

  @override
  Future<void> saveSession(StoredAuthSession value) async => session = value;
}

final class _FakePersonalProgressRepository
    implements PersonalProgressRepository {
  final List<MorningCheckingModel> checkings = [];
  final List<WeeklyReviewModel> reviews = [];
  final List<WinModel> wins = [];
  UserRewardModel? reward;
  int _nextId = 1;

  @override
  Future<ApiResult<List<MorningCheckingModel>>> getCheckings() async =>
      ApiSuccess(List.unmodifiable(checkings));

  @override
  Future<ApiResult<MorningCheckingModel>> createChecking({
    required int moodRating,
    String? notes,
  }) async {
    final item = MorningCheckingModel(
      id: _nextId++,
      userId: 1,
      moodRating: moodRating,
      checkedInAt: DateTime(2026, 9, 17, 8),
      notes: notes,
    );
    checkings.insert(0, item);
    return ApiSuccess(item);
  }

  @override
  Future<ApiResult<MorningCheckingModel>> updateChecking({
    required int id,
    required int moodRating,
    String? notes,
  }) async {
    final index = checkings.indexWhere((item) => item.id == id);
    final updated = MorningCheckingModel(
      id: id,
      userId: 1,
      moodRating: moodRating,
      checkedInAt: checkings[index].checkedInAt,
      notes: notes,
    );
    checkings[index] = updated;
    return ApiSuccess(updated);
  }

  @override
  Future<ApiResult<void>> deleteChecking(int id) async {
    checkings.removeWhere((item) => item.id == id);
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<List<WeeklyReviewModel>>> getReviews() async =>
      ApiSuccess(List.unmodifiable(reviews));

  @override
  Future<ApiResult<WeeklyReviewModel>> createReview({
    required String summary,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final item = WeeklyReviewModel(
      id: _nextId++,
      userId: 1,
      reviewSummary: summary,
      startDate: startDate,
      endDate: endDate,
      createdAt: DateTime(2026, 9, 17, 9),
    );
    reviews.insert(0, item);
    return ApiSuccess(item);
  }

  @override
  Future<ApiResult<WeeklyReviewModel>> updateReview({
    required int id,
    required String summary,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final index = reviews.indexWhere((item) => item.id == id);
    final updated = WeeklyReviewModel(
      id: id,
      userId: 1,
      reviewSummary: summary,
      startDate: startDate,
      endDate: endDate,
      createdAt: reviews[index].createdAt,
    );
    reviews[index] = updated;
    return ApiSuccess(updated);
  }

  @override
  Future<ApiResult<void>> deleteReview(int id) async {
    reviews.removeWhere((item) => item.id == id);
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<List<WinModel>>> getWins() async =>
      ApiSuccess(List.unmodifiable(wins));

  @override
  Future<ApiResult<WinModel>> createWin({
    required String title,
    String? description,
  }) async {
    final item = WinModel(
      id: _nextId++,
      userId: 1,
      title: title,
      description: description,
      createdAt: DateTime(2026, 9, 17, 10),
    );
    wins.insert(0, item);
    return ApiSuccess(item);
  }

  @override
  Future<ApiResult<WinModel>> updateWin({
    required int id,
    required String title,
    String? description,
  }) async {
    final index = wins.indexWhere((item) => item.id == id);
    final updated = WinModel(
      id: id,
      userId: 1,
      title: title,
      description: description,
      createdAt: wins[index].createdAt,
    );
    wins[index] = updated;
    return ApiSuccess(updated);
  }

  @override
  Future<ApiResult<void>> deleteWin(int id) async {
    wins.removeWhere((item) => item.id == id);
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<List<UserRewardModel>>> getRewards() async =>
      ApiSuccess(reward == null ? [] : [reward!]);

  @override
  Future<ApiResult<UserRewardModel>> addPoints(int userId, int points) async {
    final current = reward?.points ?? 0;
    final next = current + points;
    reward = UserRewardModel(
      id: reward?.id ?? _nextId++,
      userId: userId,
      points: next,
      level: (next ~/ 100) + 1,
      updatedAt: DateTime(2026, 9, 17, 11),
    );
    return ApiSuccess(reward!);
  }

  @override
  Future<ApiResult<UserRewardModel>> subtractPoints(
    int userId,
    int points,
  ) async {
    final current = reward?.points ?? 0;
    final next = (current - points).clamp(0, 999999);
    reward = UserRewardModel(
      id: reward?.id ?? _nextId++,
      userId: userId,
      points: next,
      level: (next ~/ 100) + 1,
      updatedAt: DateTime(2026, 9, 17, 11),
    );
    return ApiSuccess(reward!);
  }

  @override
  Future<ApiResult<void>> deleteReward(int id) async {
    reward = null;
    return const ApiSuccess(null);
  }
}

void main() {
  late _FakePersonalProgressRepository repository;
  late _FakeTokenStorage tokenStorage;
  late AuthSessionService sessionService;
  late PersonalProgressController controller;

  setUp(() async {
    repository = _FakePersonalProgressRepository();
    tokenStorage = _FakeTokenStorage();
    tokenStorage.session = const StoredAuthSession(
      accessToken: 'test-token',
      tokenType: 'Bearer',
      userId: 1,
    );
    sessionService = AuthSessionService(tokenStorage);
    await sessionService.restoreSession();
    controller = PersonalProgressController(repository, sessionService);
  });

  test(
    'PersonalProgressController performs full CRUD cycle for checkings',
    () async {
      await controller.load();
      expect(controller.data.checkings, isEmpty);

      final created = await controller.createChecking(
        moodRating: 8,
        notes: 'Morning checkin 1',
      );
      expect(created, isTrue);
      expect(controller.data.checkings.length, 1);
      expect(controller.data.checkings.first.notes, 'Morning checkin 1');

      final existing = controller.data.checkings.first;
      final updated = await controller.updateChecking(
        existing,
        moodRating: 9,
        notes: 'Updated morning checkin',
      );
      expect(updated, isTrue);
      expect(controller.data.checkings.first.moodRating, 9);
      expect(controller.data.checkings.first.notes, 'Updated morning checkin');

      final deleted = await controller.deleteChecking(
        controller.data.checkings.first,
      );
      expect(deleted, isTrue);
      expect(controller.data.checkings, isEmpty);
    },
  );

  test(
    'PersonalProgressController performs full CRUD cycle for weekly reviews',
    () async {
      await controller.load();
      expect(controller.data.reviews, isEmpty);

      final created = await controller.createReview(
        summary: 'Productive sprint week',
        startDate: DateTime(2026, 9, 10),
        endDate: DateTime(2026, 9, 17, 23, 59, 59),
      );
      expect(created, isTrue);
      expect(controller.data.reviews.length, 1);
      expect(
        controller.data.reviews.first.reviewSummary,
        'Productive sprint week',
      );

      final existing = controller.data.reviews.first;
      final updated = await controller.updateReview(
        existing,
        summary: 'Updated sprint week summary',
        startDate: existing.startDate,
        endDate: existing.endDate,
      );
      expect(updated, isTrue);
      expect(
        controller.data.reviews.first.reviewSummary,
        'Updated sprint week summary',
      );

      final deleted = await controller.deleteReview(
        controller.data.reviews.first,
      );
      expect(deleted, isTrue);
      expect(controller.data.reviews, isEmpty);
    },
  );

  test(
    'PersonalProgressController performs full CRUD cycle for wins',
    () async {
      await controller.load();
      expect(controller.data.wins, isEmpty);

      final created = await controller.createWin(
        title: 'Fixed all progress bugs',
        description: 'Cleaned up dialog lifecycles',
      );
      expect(created, isTrue);
      expect(controller.data.wins.length, 1);
      expect(controller.data.wins.first.title, 'Fixed all progress bugs');

      final existing = controller.data.wins.first;
      final updated = await controller.updateWin(
        existing,
        title: 'Fixed and verified all progress bugs',
        description: 'Unit and integration tests pass',
      );
      expect(updated, isTrue);
      expect(
        controller.data.wins.first.title,
        'Fixed and verified all progress bugs',
      );

      final deleted = await controller.deleteWin(controller.data.wins.first);
      expect(deleted, isTrue);
      expect(controller.data.wins, isEmpty);
    },
  );

  test(
    'PersonalProgressController manages rewards and point increments',
    () async {
      await controller.load();
      expect(controller.data.reward, isNull);

      final added = await controller.addPoints(150);
      expect(added, isTrue);
      expect(controller.data.reward?.points, 150);
      expect(controller.data.reward?.level, 2);

      final subtracted = await controller.subtractPoints(50);
      expect(subtracted, isTrue);
      expect(controller.data.reward?.points, 100);

      final reset = await controller.resetReward();
      expect(reset, isTrue);
      expect(controller.data.reward, isNull);
    },
  );
}
