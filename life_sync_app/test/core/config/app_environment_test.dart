import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/config/app_environment.dart';

void main() {
  group('AppEnvironment', () {
    test('normalizes a trailing slash', () {
      final environment = AppEnvironment(
        apiBaseUrl: ' https://api.example.com/v1/// ',
      );

      expect(environment.apiBaseUrl, 'https://api.example.com/v1');
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

    test('uses the hosted API for Android development builds', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      expect(
        AppEnvironment.current().apiBaseUrl,
        'https://lifesync-backend-bultoncr7-dev.apps.rm3.7wse.p1.openshiftapps.com',
      );
    });
  });
}
