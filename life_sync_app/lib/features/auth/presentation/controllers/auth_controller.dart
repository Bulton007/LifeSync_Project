import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';
import 'package:life_sync_app/features/auth/domain/repositories/auth_repository.dart';

final class AuthController extends GetxController {
  AuthController(this._repository, this._sessionService);

  final AuthRepository _repository;
  final AuthSessionService _sessionService;

  final isSubmitting = false.obs;
  final errorMessage = RxnString();

  Future<bool> login({required String email, required String password}) async {
    return _submit(() async {
      final result = await _repository.login(
        email: email.trim(),
        password: password,
      );

      return result.when(
        success: (response) async {
          await _sessionService.saveSession(
            StoredAuthSession(
              accessToken: response.accessToken,
              tokenType: response.tokenType,
              userId: response.userId,
            ),
          );
          return true;
        },
        failure: _recordFailure,
      );
    });
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) => _request(
    () => _repository.register(
      fullName: fullName.trim(),
      email: email.trim(),
      password: password,
    ),
  );

  Future<bool> verifyOtp({required String email, required String otpCode}) =>
      _request(
        () => _repository.verifyOtp(email: email.trim(), otpCode: otpCode),
      );

  Future<bool> resendOtp(String email) =>
      _request(() => _repository.resendOtp(email.trim()));

  Future<bool> forgotPassword(String email) =>
      _request(() => _repository.forgotPassword(email.trim()));

  Future<bool> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  }) => _request(
    () => _repository.resetPassword(
      email: email.trim(),
      otpCode: otpCode,
      newPassword: newPassword,
    ),
  );

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final session = _sessionService.currentSession;
    if (session == null) {
      errorMessage.value = 'Your session has expired. Sign in again.';
      return false;
    }

    return _request(
      () => _repository.changePassword(
        userId: session.userId,
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }

  Future<void> logout() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      await _repository.logout();
    } finally {
      await _sessionService.clearSession();
      isSubmitting.value = false;
      await Get.offAllNamed<void>(AppRoutes.signIn);
    }
  }

  void clearError() => errorMessage.value = null;

  Future<bool> _request(Future<ApiResult<String>> Function() operation) {
    return _submit(() async {
      final result = await operation();
      return result.when(success: (_) => true, failure: _recordFailure);
    });
  }

  Future<bool> _submit(Future<bool> Function() operation) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      return await operation();
    } on Object {
      errorMessage.value = 'The operation could not be completed.';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  bool _recordFailure(dynamic exception) {
    errorMessage.value = exception.message as String;
    return false;
  }
}
