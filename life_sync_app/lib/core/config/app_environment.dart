import 'package:flutter/foundation.dart';

/// Runtime configuration shared by every remote data source.
///
/// Override the development default with:
/// `--dart-define=API_BASE_URL=https://api.example.com`.
///
/// The legacy `LIFE_SYNC_API_BASE_URL` key is still accepted.
final class AppEnvironment {
  AppEnvironment({
    required String apiBaseUrl,
    this.connectTimeout = const Duration(seconds: 8),
    this.sendTimeout = const Duration(seconds: 8),
    this.receiveTimeout = const Duration(seconds: 10),
  }) : apiBaseUrl = _normalizeAndValidate(apiBaseUrl);

  factory AppEnvironment.current() {
    const configuredBaseUrl = String.fromEnvironment('API_BASE_URL');
    const legacyConfiguredBaseUrl = String.fromEnvironment(
      'LIFE_SYNC_API_BASE_URL',
    );
    final selectedBaseUrl = configuredBaseUrl.trim().isNotEmpty
        ? configuredBaseUrl
        : legacyConfiguredBaseUrl;

    if (selectedBaseUrl.trim().isEmpty && kReleaseMode) {
      throw StateError(
        'API_BASE_URL must be provided for release builds.',
      );
    }

    return AppEnvironment(
      apiBaseUrl: selectedBaseUrl.trim().isNotEmpty
          ? selectedBaseUrl
          : _developmentBaseUrl,
    );
  }

  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;

  static const _androidDevelopmentBaseUrl =
      'https://lifesync-backend-bultoncr7-dev.apps.rm3.7wse.p1.openshiftapps.com';

  static String get _developmentBaseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return _androidDevelopmentBaseUrl;
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
