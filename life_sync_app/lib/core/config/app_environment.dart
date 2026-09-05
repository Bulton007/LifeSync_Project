import 'package:flutter/foundation.dart';

/// Runtime configuration shared by every remote data source.
///
/// Override the development default with:
/// `--dart-define=LIFE_SYNC_API_BASE_URL=https://api.example.com`.
final class AppEnvironment {
  AppEnvironment({
    required String apiBaseUrl,
    this.connectTimeout = const Duration(seconds: 8),
    this.sendTimeout = const Duration(seconds: 8),
    this.receiveTimeout = const Duration(seconds: 10),
  }) : apiBaseUrl = _normalizeAndValidate(apiBaseUrl);

  factory AppEnvironment.current() {
    const configuredBaseUrl = String.fromEnvironment('LIFE_SYNC_API_BASE_URL');

    if (configuredBaseUrl.trim().isEmpty && kReleaseMode) {
      throw StateError(
        'LIFE_SYNC_API_BASE_URL must be provided for release builds.',
      );
    }

    return AppEnvironment(
      apiBaseUrl: configuredBaseUrl.trim().isNotEmpty
          ? configuredBaseUrl
          : _developmentBaseUrl,
    );
  }

  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;

  static String get _developmentBaseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8085';
    }

    return 'http://localhost:8085';
  }

  static String _normalizeAndValidate(String value) {
    final normalized = value.trim().replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.tryParse(normalized);

    if (uri == null ||
        !uri.hasAuthority ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw ArgumentError.value(
        value,
        'apiBaseUrl',
        'Must be an absolute HTTP or HTTPS URL.',
      );
    }

    return normalized;
  }
}
