import 'package:dio/dio.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';

typedef UnauthorizedCallback = Future<void> Function();

/// Adds the current bearer token and coordinates a single session reset on 401.
final class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._tokenStorage, this._onUnauthorized);

  static const skipAuthenticationKey = 'skipAuthentication';

  final TokenStorage _tokenStorage;
  final UnauthorizedCallback _onUnauthorized;
  bool _isHandlingUnauthorized = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuthenticationKey] == true) {
      handler.next(options);
      return;
    }

    try {
      final session = await _tokenStorage.readSession();
      if (session != null) {
        options.headers['Authorization'] = session.authorizationHeader;
      }
    } on Object {
      // A storage failure must not leak data or crash a public request. A
      // protected endpoint will respond with 401 and use the standard flow.
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final shouldResetSession =
        err.response?.statusCode == 401 &&
        err.requestOptions.extra[skipAuthenticationKey] != true &&
        !_isHandlingUnauthorized;

    if (shouldResetSession) {
      _isHandlingUnauthorized = true;
      try {
        await _onUnauthorized();
      } finally {
        _isHandlingUnauthorized = false;
      }
    }

    handler.next(err);
  }
}
