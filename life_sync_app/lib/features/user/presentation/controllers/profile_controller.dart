import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';
import 'package:life_sync_app/features/user/data/models/user_profile_model.dart';
import 'package:life_sync_app/features/user/domain/repositories/user_repository.dart';

final class ProfileController extends GetxController {
  ProfileController(this._repository, this._sessionService, this._imagePicker);

  final UserRepository _repository;
  final AuthSessionService _sessionService;
  final ImagePicker _imagePicker;

  final state = const AsyncViewState<UserProfileModel>.initial().obs;
  final imageBytes = Rxn<Uint8List>();
  final isSubmitting = false.obs;
  final errorMessage = RxnString();

  int? get _userId => _sessionService.currentSession?.userId;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile({bool refresh = false}) async {
    final userId = _userId;
    if (userId == null) {
      await _sessionService.handleUnauthorized();
      return;
    }

    final previous = state.value.data;
    state.value = refresh && previous != null
        ? AsyncViewState<UserProfileModel>.refreshing(previous)
        : const AsyncViewState<UserProfileModel>.loading();

    final result = await _repository.getProfile(userId);
    result.when(
      success: (profile) {
        state.value = AsyncViewState<UserProfileModel>.success(profile);
        if (profile.profileImage != null) {
          _loadImage(userId);
        } else {
          imageBytes.value = null;
        }
      },
      failure: (exception) {
        state.value = AsyncViewState<UserProfileModel>.error(
          exception,
          previousData: previous,
        );
      },
    );
  }

  Future<bool> updateProfile({
    required String fullName,
    required String email,
    String? phoneNumber,
  }) async {
    final userId = _userId;
    if (userId == null || isSubmitting.value) return false;

    final oldEmail = state.value.data?.email;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.updateProfile(
        userId: userId,
        fullName: fullName.trim(),
        email: email.trim(),
        phoneNumber: _normalizedPhone(phoneNumber),
      );
      return result.when(
        success: (profile) {
          state.value = AsyncViewState<UserProfileModel>.success(profile);
          if (oldEmail != null && oldEmail != profile.email) {
            _sessionService.clearSession().then(
              (_) => Get.offAllNamed<void>(AppRoutes.signIn),
            );
          }
          return true;
        },
        failure: _recordFailure,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> pickAndUploadImage() async {
    if (isSubmitting.value) return false;
    final selected = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 88,
      requestFullMetadata: false,
    );
    if (selected == null) return false;

    final userId = _userId;
    if (userId == null) return false;

    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.uploadProfileImage(
        userId: userId,
        filePath: selected.path,
        fileName: selected.name,
      );
      return await result.when(
        success: (_) async {
          await loadProfile(refresh: true);
          return true;
        },
        failure: (exception) async => _recordFailure(exception),
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteImage() async {
    final userId = _userId;
    if (userId == null || isSubmitting.value) return false;

    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.deleteProfileImage(userId);
      return result.when(
        success: (_) {
          imageBytes.value = null;
          final profile = state.value.data;
          if (profile != null) loadProfile(refresh: true);
          return true;
        },
        failure: _recordFailure,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _loadImage(int userId) async {
    final result = await _repository.getProfileImage(userId);
    result.when(
      success: (bytes) => imageBytes.value = bytes,
      failure: (_) => imageBytes.value = null,
    );
  }

  bool _recordFailure(ApiException exception) {
    errorMessage.value = exception.message;
    return false;
  }

  String? _normalizedPhone(String? phoneNumber) {
    final normalized = phoneNumber?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }
}
