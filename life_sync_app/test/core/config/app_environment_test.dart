import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/config/app_environment.dart';

void main() {
  group('AppEnvironment', () {
    test('accepts an HTTPS origin and normalizes trailing slashes', () {
      expect(
        AppEnvironment(apiBaseUrl: ' https://api.example.com/// ').apiBaseUrl,
        'https://api.example.com',
      );
    });

    test('rejects a non-root API path', () {
      expect(
        () => AppEnvironment(apiBaseUrl: 'https://api.example.com/api'),
        throwsArgumentError,
      );
    });

    test('rejects query strings, fragments, and credentials', () {
      for (final value in <String>[
        'https://api.example.com?tenant=one',
        'https://api.example.com/#fragment',
        'https://user:password@api.example.com',
      ]) {
        expect(() => AppEnvironment(apiBaseUrl: value), throwsArgumentError);
      }
    });

    test('rejects a relative base URL', () {
      expect(() => AppEnvironment(apiBaseUrl: '/api'), throwsArgumentError);
    });

    test('provides a valid development environment', () {
      final environment = AppEnvironment.current();
      final uri = Uri.parse(environment.apiBaseUrl);

      expect(uri.isAbsolute, isTrue);
      expect(uri.host, isNotEmpty);
      expect(uri.scheme, anyOf('http', 'https'));
    });

    test('defaults to the deployed HTTPS origin on Android', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      expect(
        AppEnvironment.current().apiBaseUrl,
        AppEnvironment.defaultApiBaseUrl,
      );
      expect(Uri.parse(AppEnvironment.current().apiBaseUrl).scheme, 'https');
    });
  });
}
