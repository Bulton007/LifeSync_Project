import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/auth/data/models/auth_models.dart';

abstract interface class AuthRepository {
  Future<ApiResult<String>> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<ApiResult<LoginResponseModel>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<String>> verifyOtp({
    required String email,
    required String otpCode,
  });

  Future<ApiResult<String>> resendOtp(String email);

  Future<ApiResult<String>> forgotPassword(String email);

  Future<ApiResult<String>> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  });

  Future<ApiResult<String>> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  });

  Future<ApiResult<String>> logout();
}
