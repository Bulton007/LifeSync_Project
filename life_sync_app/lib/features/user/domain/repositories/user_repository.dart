import 'dart:typed_data';

import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/user/data/models/user_profile_model.dart';

abstract interface class UserRepository {
  Future<ApiResult<UserProfileModel>> getProfile(int userId);

  Future<ApiResult<UserProfileModel>> updateProfile({
    required int userId,
    required String fullName,
    required String email,
    String? phoneNumber,
  });

  Future<ApiResult<String>> uploadProfileImage({
    required int userId,
    required String filePath,
    required String fileName,
  });

  Future<ApiResult<String>> deleteProfileImage(int userId);

  Future<ApiResult<Uint8List>> getProfileImage(int userId);
}
