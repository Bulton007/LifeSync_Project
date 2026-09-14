import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';
import 'package:life_sync_app/features/auth/data/models/auth_models.dart';
import 'package:life_sync_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:life_sync_app/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  group('AuthController', () {
    late _FakeAuthRepository repository;
    late _MemoryTokenStorage tokenStorage;
    late AuthController controller;

    setUp(() {
      repository = _FakeAuthRepository();
      tokenStorage = _MemoryTokenStorage();
      controller = AuthController(repository, AuthSessionService(tokenStorage));
    });

    test('stores JWT securely after login success', () async {
      repository.loginResult = const ApiSuccess(
        LoginResponseModel(
          accessToken: 'jwt-token',
          tokenType: 'Bearer',
          userId: 42,
          fullName: 'Codex Tester',
          email: 'codex@example.com',
        ),
      );

      final signedIn = await controller.login(
        email: ' CODEX@EXAMPLE.COM ',
        password: 'Test123456',
      );

      expect(signedIn, isTrue);
      expect(repository.lastEmail, 'codex@example.com');
      expect((await tokenStorage.readSession())?.accessToken, 'jwt-token');
    });

    test('records safe message after login failure', () async {
      repository.loginResult = const ApiFailure(
        ApiException(
          type: ApiFailureType.unauthorized,
          message: 'Incorrect email or password.',
          statusCode: 401,
        ),
      );

      final signedIn = await controller.login(
        email: 'codex@example.com',
        password: 'wrong-password',
      );

      expect(signedIn, isFalse);
      expect(controller.errorMessage.value, 'Incorrect email or password.');
    });

    test('prevents duplicate registration submits', () async {
      final completer = Completer<ApiResult<String>>();
      repository.registerCompleter = completer;

      final first = controller.register(
        fullName: 'Codex Tester',
        email: 'codex@example.com',
        password: 'Test123456',
      );
      final second = await controller.register(
        fullName: 'Codex Tester',
        email: 'codex@example.com',
        password: 'Test123456',
      );

      completer.complete(const ApiSuccess('OTP sent.'));

      expect(await first, isTrue);
      expect(second, isFalse);
      expect(repository.registerCalls, 1);
    });

    test('surfaces invalid and expired OTP messages', () async {
      repository.verifyOtpResult = const ApiFailure(
        ApiException(
          type: ApiFailureType.badRequest,
          message: 'OTP expired.',
          statusCode: 400,
        ),
      );

      final verified = await controller.verifyOtp(
        email: 'codex@example.com',
        otpCode: '123456',
      );

      expect(verified, isFalse);
      expect(controller.errorMessage.value, 'OTP expired.');
    });
  });
}

final class _FakeAuthRepository implements AuthRepository {
  ApiResult<String> registerResult = const ApiSuccess('Registered.');
  ApiResult<LoginResponseModel> loginResult = const ApiFailure(
    ApiException(
      type: ApiFailureType.unauthorized,
      message: 'Incorrect email or password.',
    ),
  );
  ApiResult<String> verifyOtpResult = const ApiSuccess('Verified.');
  Completer<ApiResult<String>>? registerCompleter;
  int registerCalls = 0;
  String? lastEmail;

  @override
  Future<ApiResult<String>> register({
    required String fullName,
    required String email,
    required String password,
  }) {
    registerCalls += 1;
    lastEmail = email;
    return registerCompleter?.future ?? Future.value(registerResult);
  }

  @override
  Future<ApiResult<LoginResponseModel>> login({
    required String email,
    required String password,
  }) {
    lastEmail = email;
    return Future.value(loginResult);
  }

  @override
  Future<ApiResult<String>> verifyOtp({
    required String email,
    required String otpCode,
  }) => Future.value(verifyOtpResult);

  @override
  Future<ApiResult<String>> resendOtp(
    String email, {
    String channel = 'email',
  }) => Future.value(const ApiSuccess('OTP has been resent.'));

  @override
  Future<ApiResult<String>> forgotPassword(String email) =>
      Future.value(const ApiSuccess('OTP sent to email.'));

  @override
  Future<ApiResult<String>> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  }) => Future.value(const ApiSuccess('Password reset successfully.'));

  @override
  Future<ApiResult<String>> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) => Future.value(const ApiSuccess('Password changed successfully.'));

  @override
  Future<ApiResult<String>> logout() =>
      Future.value(const ApiSuccess('Logout successful.'));
}

final class _MemoryTokenStorage implements TokenStorage {
  StoredAuthSession? session;

  @override
  Future<void> clearSession() async {
    session = null;
  }

  @override
  Future<StoredAuthSession?> readSession() async => session;

  @override
  Future<void> saveSession(StoredAuthSession session) async {
    this.session = session;
  }
}
