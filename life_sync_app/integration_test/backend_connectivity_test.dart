import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('emulator reaches deployed backend over HTTPS', (tester) async {
    const baseUrl = String.fromEnvironment('API_BASE_URL');
    expect(baseUrl, isNotEmpty);
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 20);
    try {
      final request = await client.getUrl(Uri.parse('$baseUrl/api/health'));
      final response = await request.close().timeout(
        const Duration(seconds: 25),
      );
      expect(response.statusCode, HttpStatus.ok);
      final body = await utf8.decoder.bind(response).join();
      expect((jsonDecode(body) as Map<String, dynamic>)['status'], 'UP');
    } finally {
      client.close(force: true);
    }
  });
}
