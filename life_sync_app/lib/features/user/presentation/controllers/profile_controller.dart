import 'package:flutter/services.dart';

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
    if (_userId != userId) return;
    await result.when<Future<void>>(
      success: (profile) async {
        state.value = AsyncViewState<UserProfileModel>.success(profile);
        if (profile.profileImage != null) {
          await _loadImage(userId);
        } else {
          imageBytes.value = null;
        }
      },
      failure: (exception) async {
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
      final bool success = result.when<bool>(
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
      return success;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> pickAndUploadImage() async {
    final userId = _userId;
    if (userId == null || isSubmitting.value) return false;

    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final selected = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 88,
        requestFullMetadata: false,
      );
      if (selected == null || _userId != userId) return false;
      final extension = selected.name.split('.').last.toLowerCase();
      if (!{'jpg', 'jpeg', 'png', 'webp'}.contains(extension)) {
        errorMessage.value = 'Profile image must be JPG, PNG, or WebP.';
        return false;
      }
      final size = await selected.length();
      if (size == 0 || size > 5 * 1024 * 1024) {
        errorMessage.value = 'Choose a non-empty image smaller than 5 MB.';
        return false;
      }
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
    } on PlatformException {
      errorMessage.value =
          'Unable to open photos. Check photo permissions in phone settings.';
      return false;
    } catch (_) {
      errorMessage.value = 'Unable to upload your photo. Please try again.';
      return false;
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
      final bool success = result.when<bool>(
        success: (_) {
          imageBytes.value = null;
          final profile = state.value.data;
          if (profile != null) loadProfile(refresh: true);
          return true;
        },
        failure: _recordFailure,
      );
      return success;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _loadImage(int userId) async {
    final result = await _repository.getProfileImage(userId);
    if (_userId != userId) return;
    result.when(
      success: (bytes) => imageBytes.value = bytes,
      failure: (exception) => errorMessage.value = exception.message,
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
