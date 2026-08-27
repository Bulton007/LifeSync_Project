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
      expect(uri.port, 8085);
    });
  });
}
