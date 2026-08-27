import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:life_sync_app/features/auth/data/models/auth_models.dart';
import 'package:life_sync_app/features/auth/domain/repositories/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<String>> register({
    required String fullName,
    required String email,
    required String password,
  }) => _remoteDataSource.register(
    fullName: fullName,
    email: email,
    password: password,
  );

  @override
  Future<ApiResult<LoginResponseModel>> login({
    required String email,
    required String password,
  }) => _remoteDataSource.login(email: email, password: password);

  @override
  Future<ApiResult<String>> verifyOtp({
    required String email,
    required String otpCode,
  }) => _remoteDataSource.verifyOtp(email: email, otpCode: otpCode);

  @override
  Future<ApiResult<String>> resendOtp(String email) =>
      _remoteDataSource.resendOtp(email);

  @override
  Future<ApiResult<String>> forgotPassword(String email) =>
      _remoteDataSource.forgotPassword(email);

  @override
  Future<ApiResult<String>> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
  }) => _remoteDataSource.resetPassword(
    email: email,
    otpCode: otpCode,
    newPassword: newPassword,
  );

  @override
  Future<ApiResult<String>> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) => _remoteDataSource.changePassword(
    userId: userId,
    currentPassword: currentPassword,
    newPassword: newPassword,
  );

  @override
  Future<ApiResult<String>> logout() => _remoteDataSource.logout();
}
