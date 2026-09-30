import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/features/auth/data/models/auth_models.dart';

class GoogleAuthService {
  GoogleAuthService(this.client);
  final ApiClient client;
  Future<void>? _initialization;

  Future<ApiResult<LoginResponseModel>?> signIn() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      throw UnsupportedError(
        'Google sign-in is supported on Android and iOS only.',
      );
    }
    _initialization ??= _initialize();
    await _initialization;
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );
      final result = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final token = await result.user?.getIdToken(true);
      if (token == null || token.isEmpty) {
        throw StateError('Google did not return a verified sign-in token.');
      }
      return await client.post<LoginResponseModel>(
        '/api/auth/google',
        data: {'idToken': token},
        skipAuthentication: true,
        decoder: (data) => LoginResponseModel.fromJson(
          Map<String, dynamic>.from(data! as Map),
        ),
      );
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    } finally {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
    }
  }

  Future<void> _initialize() async {
    try {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp();
      await GoogleSignIn.instance.initialize();
    } catch (_) {
      _initialization = null;
      rethrow;
    }
  }
}
