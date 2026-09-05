import 'package:dio/dio.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/auth/data/models/auth_models.dart';

final class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResult<String>> register({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _apiClient.post<String>(
      '/api/auth/register',
      data: {'fullName': fullName, 'email': email, 'password': password},
      decoder: _decodeMessage,
      responseType: ResponseType.plain,
      skipAuthentication: true,
    );
  }

  Future<ApiResult<LoginResponseModel>> login({
    required String email,
    required String password,
  }) {
    return _apiClient.post<LoginResponseModel>(
      '/api/auth/login',
      data: {'email': email, 'password': password},
      decoder: (data) =>
          LoginResponseModel.fromJson(Map<String, dynamic>.from(data! as Map)),
      skipAuthentication: true,
    );
  }

  Future<ApiResult<String>> verifyOtp({
    required String email,
    required String otpCode,
  }) {
    return _apiClient.post<String>(
      '/api/auth/verify-otp',
      data: {'email': email, 'otpCode': otpCode},
      decoder: _decodeMessage,
      responseType: ResponseType.plain,
      skipAuthentication: true,
    );
  }

  Future<ApiResult<String>> resendOtp(String email) {
    return _apiClient.post<String>(
      '/api/auth/resend-otp',
      queryParameters: {'email': email},
      decoder: _decodeMessage,
      responseType: ResponseType.plain,
      skipAuthentication: true,
    );
  }

  Future<ApiResult<String>> forgotPassword(String email) {
    return _apiClient.post<String>(
      '/api/auth/forgot-password',
      data: {'email': email},
      decoder: _decodeMessage,
      responseType: ResponseType.plain,
      skipAuthentication: true,
    );
  }

  Future<ApiResult<String>> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  }) {
    return _apiClient.post<String>(
      '/api/auth/reset-password',
      data: {'email': email, 'otpCode': otpCode, 'newPassword': newPassword},
      decoder: _decodeMessage,
      responseType: ResponseType.plain,
      skipAuthentication: true,
    );
  }

  Future<ApiResult<String>> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) {
    return _apiClient.put<String>(
      '/api/auth/change-password/$userId',
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      decoder: _decodeMessage,
      responseType: ResponseType.plain,
    );
  }

  Future<ApiResult<String>> logout() {
    return _apiClient.post<String>(
      '/api/auth/logout',
      decoder: _decodeMessage,
      responseType: ResponseType.plain,
    );
  }

  static String _decodeMessage(Object? data) {
    if (data is String) {
      return data;
    }
    throw const FormatException('Expected a text response.');
  }
}
