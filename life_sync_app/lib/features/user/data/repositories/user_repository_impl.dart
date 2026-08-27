import 'dart:typed_data';

import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/user/data/datasources/user_remote_data_source.dart';
import 'package:life_sync_app/features/user/data/models/user_profile_model.dart';
import 'package:life_sync_app/features/user/domain/repositories/user_repository.dart';

final class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._remoteDataSource);

  final UserRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<UserProfileModel>> getProfile(int userId) =>
      _remoteDataSource.getProfile(userId);

  @override
  Future<ApiResult<UserProfileModel>> updateProfile({
    required int userId,
    required String fullName,
    required String email,
    String? phoneNumber,
  }) => _remoteDataSource.updateProfile(
    userId: userId,
    fullName: fullName,
    email: email,
    phoneNumber: phoneNumber,
  );

  @override
  Future<ApiResult<String>> uploadProfileImage({
    required int userId,
    required String filePath,
    required String fileName,
  }) => _remoteDataSource.uploadProfileImage(
    userId: userId,
    filePath: filePath,
    fileName: fileName,
  );

  @override
  Future<ApiResult<String>> deleteProfileImage(int userId) =>
      _remoteDataSource.deleteProfileImage(userId);

  @override
  Future<ApiResult<Uint8List>> getProfileImage(int userId) =>
      _remoteDataSource.getProfileImage(userId);
}
