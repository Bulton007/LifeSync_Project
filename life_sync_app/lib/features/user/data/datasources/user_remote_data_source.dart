import 'dart:typed_data';

import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/user/data/models/user_profile_model.dart';

final class UserRemoteDataSource {
  const UserRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResult<UserProfileModel>> getProfile(int userId) {
    return _apiClient.get<UserProfileModel>(
      '/api/users/$userId',
      decoder: _decodeProfile,
    );
  }

  Future<ApiResult<UserProfileModel>> updateProfile({
    required int userId,
    required String fullName,
    required String email,
    String? phoneNumber,
  }) {
    return _apiClient.put<UserProfileModel>(
      '/api/users/$userId',
      data: {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
      },
      decoder: _decodeProfile,
    );
  }

  Future<ApiResult<String>> uploadProfileImage({
    required int userId,
    required String filePath,
    required String fileName,
  }) {
    return _apiClient.uploadFile<String>(
      '/api/users/$userId/profile-image',
      filePath: filePath,
      fileName: fileName,
      fieldName: 'file',
      decoder: _decodeMessage,
    );
  }

  Future<ApiResult<String>> deleteProfileImage(int userId) {
    return _apiClient.delete<String>(
      '/api/users/$userId/profile-image',
      decoder: _decodeMessage,
    );
  }

  Future<ApiResult<Uint8List>> getProfileImage(int userId) {
    return _apiClient.getBytes('/api/users/$userId/profile-image');
  }

  static UserProfileModel _decodeProfile(Object? data) {
    return UserProfileModel.fromJson(Map<String, dynamic>.from(data! as Map));
  }

  static String _decodeMessage(Object? data) {
    if (data is String) return data;
    throw const FormatException('Expected a text response.');
  }
}
