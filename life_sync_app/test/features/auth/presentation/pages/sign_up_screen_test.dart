import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';
import 'package:life_sync_app/features/auth/data/models/auth_models.dart';
import 'package:life_sync_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:life_sync_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:life_sync_app/views/authentication/sign_up_screen.dart';
import 'package:life_sync_app/views/authentication/forgot_password_screen.dart';
import 'package:life_sync_app/views/authentication/sign_up_verify_email_screen.dart';

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

    for (final failFirstLogin in [false, true]) {
      testWidgets('verified registration opens Home (retry: $failFirstLogin)', (
        tester,
      ) async {
        mockRepo.failFirstLogin = failFirstLogin;
        await tester.pumpWidget(
          GetMaterialApp(
            home: const Scaffold(),
            getPages: [
              GetPage(
                name: '/verify-test',
                page: () => const SignUpVerifyEmailScreen(),
              ),
              GetPage(
                name: AppRoutes.shell,
                page: () => const Scaffold(body: Text('Home ready')),
              ),
            ],
          ),
        );
        Get.toNamed(
          '/verify-test',
          arguments: const AuthFlowArguments(
            email: 'test@example.com',
            password: 'Test-password-123',
            purpose: AuthFlowPurpose.registration,
          ),
        );
        await tester.pumpAndSettle();
        final fields = find.byType(TextField);
        for (var index = 0; index < fields.evaluate().length; index++) {
          await tester.enterText(fields.at(index), '1');
        }
        await tester.pump();
        await tester.ensureVisible(find.text('Verify'));
        await tester.tap(find.text('Verify'));
        await tester.pumpAndSettle();
        if (failFirstLogin) {
          expect(find.text('Home ready'), findsNothing);
          await tester.tap(find.text('Verify'));
          await tester.pumpAndSettle();
        }
        expect(mockRepo.authCalls, [
          'verify',
          'login',
          if (failFirstLogin) 'login',
        ]);
        expect(find.text('Home ready'), findsOneWidget);
      });
    }

    testWidgets('email remains readable on the white card in dark mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        GetMaterialApp(theme: ThemeData.dark(), home: const SignUpScreen()),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.style.color, Colors.black87);
    });

    testWidgets('forgot-password email is readable with a dark app theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const ForgotPasswordScreen(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).style.color,
        Colors.black87,
      );
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
  final authCalls = <String>[];
  bool failFirstLogin = false;

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
  }) async {
    authCalls.add('login');
    if (failFirstLogin) {
      failFirstLogin = false;
      return const ApiFailure(
        ApiException(type: ApiFailureType.network, message: 'Try again'),
      );
    }
    return const ApiSuccess(
      LoginResponseModel(
        accessToken: 'token',
        tokenType: 'Bearer',
        userId: 1,
        fullName: 'Test',
        email: 'test@example.com',
      ),
    );
  }

  @override
  Future<ApiResult<String>> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    authCalls.add('verify');
    return const ApiSuccess('Verified');
  }

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
