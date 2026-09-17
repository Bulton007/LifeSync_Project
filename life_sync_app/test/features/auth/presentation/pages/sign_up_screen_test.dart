import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';
import 'package:life_sync_app/features/auth/data/models/auth_models.dart';
import 'package:life_sync_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:life_sync_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:life_sync_app/views/authentication/sign_up_screen.dart';

void main() {
  group('SignUpScreen', () {
    late _MockAuthRepo mockRepo;
    late AuthController authController;

    setUp(() {
      Get.reset();
      mockRepo = _MockAuthRepo();
      final tokenStorage = _MockTokenStorage();
      authController = AuthController(
        mockRepo,
        AuthSessionService(tokenStorage),
      );
      Get.put<AuthController>(authController);
    });

    tearDown(() {
      Get.reset();
    });

    Widget createTestWidget() {
      return GetMaterialApp(
        initialRoute: AppRoutes.signUp,
        getPages: [
          GetPage<void>(
            name: AppRoutes.signUp,
            page: () => const SignUpScreen(),
          ),
          GetPage<void>(
            name: AppRoutes.createPassword,
            page: () => const Scaffold(body: Text('Create Password Screen')),
          ),
        ],
      );
    }

    testWidgets(
      'prevents navigation to createPassword and shows error when email already exists',
      (tester) async {
        mockRepo.emailExists = true;

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter existing email
        final emailField = find.byType(TextFormField);
        expect(emailField, findsOneWidget);
        await tester.enterText(emailField, 'existing@example.com');
        await tester.pump();

        // Tap Continue
        final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
        expect(continueButton, findsOneWidget);
        await tester.tap(continueButton);
        await tester.pumpAndSettle();

        // Must show error message
        expect(find.text('Email is already registered.'), findsOneWidget);

        // Must stay on sign up screen, NOT navigate to create password
        expect(find.text('Create Password Screen'), findsNothing);
        expect(find.text('Progress Starts'), findsOneWidget);
      },
    );

    testWidgets('navigates to createPassword when email is not registered', (
      tester,
    ) async {
      mockRepo.emailExists = false;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter new email
      final emailField = find.byType(TextFormField);
      await tester.enterText(emailField, 'brandnew@example.com');
      await tester.pump();

      // Tap Continue
      final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      // Must navigate to create password screen
      expect(find.text('Create Password Screen'), findsOneWidget);
    });

    testWidgets('clears error message when user modifies the email field', (
      tester,
    ) async {
      mockRepo.emailExists = true;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField);
      await tester.enterText(emailField, 'existing@example.com');
      await tester.pump();

      final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(find.text('Email is already registered.'), findsOneWidget);

      // Type something new into email field
      await tester.enterText(emailField, 'existing2@example.com');
      await tester.pumpAndSettle();

      // Error message should be cleared
      expect(find.text('Email is already registered.'), findsNothing);
    });
  });
}

final class _MockAuthRepo implements AuthRepository {
  bool emailExists = false;

  @override
  Future<ApiResult<bool>> checkEmailExists(String email) async {
    return ApiSuccess(emailExists);
  }

  @override
  Future<ApiResult<String>> register({
    required String fullName,
    required String email,
    required String password,
  }) async => const ApiSuccess('Registered');

  @override
  Future<ApiResult<LoginResponseModel>> login({
    required String email,
    required String password,
  }) async => const ApiSuccess(
    LoginResponseModel(
      accessToken: 'token',
      tokenType: 'Bearer',
      userId: 1,
      fullName: 'Test',
      email: 'test@example.com',
    ),
  );

  @override
  Future<ApiResult<String>> verifyOtp({
    required String email,
    required String otpCode,
  }) async => const ApiSuccess('Verified');

  @override
  Future<ApiResult<String>> resendOtp(
    String email, {
    String channel = 'email',
  }) async => const ApiSuccess('Resent');

  @override
  Future<ApiResult<String>> forgotPassword(String email) async =>
      const ApiSuccess('Forgot');

  @override
  Future<ApiResult<String>> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  }) async => const ApiSuccess('Reset');

  @override
  Future<ApiResult<String>> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async => const ApiSuccess('Changed');

  @override
  Future<ApiResult<String>> logout() async => const ApiSuccess('Logout');
}

final class _MockTokenStorage implements TokenStorage {
  StoredAuthSession? _session;

  @override
  Future<void> clearSession() async {
    _session = null;
  }

  @override
  Future<StoredAuthSession?> readSession() async => _session;

  @override
  Future<void> saveSession(StoredAuthSession session) async {
    _session = session;
  }
}
