import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/config/app_environment.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';

void main() {
  group('ApiClient', () {
    late _RecordingAdapter adapter;
    late _MemoryTokenStorage tokenStorage;
    late int unauthorizedCalls;
    late ApiClient client;

    setUp(() {
      adapter = _RecordingAdapter();
      tokenStorage = _MemoryTokenStorage(
        const StoredAuthSession(
          accessToken: 'test-token',
          tokenType: 'Bearer',
          userId: 7,
        ),
      );
      unauthorizedCalls = 0;
      final dio = Dio()..httpClientAdapter = adapter;
      client = ApiClient(
        environment: AppEnvironment(apiBaseUrl: 'https://api.example.com'),
        tokenStorage: tokenStorage,
        onUnauthorized: () async {
          unauthorizedCalls += 1;
          await tokenStorage.clearSession();
        },
        dio: dio,
      );
    });

    test('attaches the persisted bearer token', () async {
      final result = await client.get<Map<String, Object?>>(
        '/api/tasks',
        decoder: _decodeMap,
      );

      expect(result, isA<ApiSuccess<Map<String, Object?>>>());
      expect(
        adapter.lastRequest?.headers['Authorization'],
        'Bearer test-token',
      );
    });

    test('can explicitly skip authentication', () async {
      await client.post<Map<String, Object?>>(
        '/api/auth/login',
        data: const {'email': 'person@example.com', 'password': 'secret'},
        decoder: _decodeMap,
        skipAuthentication: true,
      );

      expect(adapter.lastRequest?.headers['Authorization'], isNull);
    });

    test('supports explicit plain text responses', () async {
      adapter
        ..body = 'Register successfully. Please verify your OTP.'
        ..contentType = Headers.textPlainContentType;

      final result = await client.post<String>(
        '/api/auth/register',
        data: const {
          'fullName': 'Codex Tester',
          'email': 'codex@example.com',
          'password': 'Test123456',
        },
        decoder: (data) => data! as String,
        responseType: ResponseType.plain,
        skipAuthentication: true,
      );

      expect(result.dataOrNull, 'Register successfully. Please verify your OTP.');
      expect(adapter.lastRequest?.responseType, ResponseType.plain);
    });

    test('normalizes 401 and resets the session once', () async {
      adapter
        ..statusCode = 401
        ..body = '{"message":"JWT token is expired"}';

      final result = await client.get<Map<String, Object?>>(
        '/api/tasks',
        decoder: _decodeMap,
      );

      expect(result, isA<ApiFailure<Map<String, Object?>>>());
      expect(result.errorOrNull?.type, ApiFailureType.unauthorized);
      expect(result.errorOrNull?.message, 'JWT token is expired');
      expect(unauthorizedCalls, 1);
      expect(await tokenStorage.readSession(), isNull);
    });

    test('normalizes decoder failures', () async {
      final result = await client.get<int>(
        '/api/tasks',
        decoder: (data) => (data as Map<String, Object?>)['missing'] as int,
      );

      expect(result.errorOrNull?.type, ApiFailureType.serialization);
    });
  });
}

Map<String, Object?> _decodeMap(Object? data) {
  return Map<String, Object?>.from(data! as Map);
}

final class _MemoryTokenStorage implements TokenStorage {
  _MemoryTokenStorage(this.session);

  StoredAuthSession? session;

  @override
  Future<void> clearSession() async {
    session = null;
  }

  @override
  Future<StoredAuthSession?> readSession() async => session;

  @override
  Future<void> saveSession(StoredAuthSession session) async {
    this.session = session;
  }
}

final class _RecordingAdapter implements HttpClientAdapter {
  int statusCode = 200;
  String body = '{"ok":true}';
  String contentType = Headers.jsonContentType;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [contentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
