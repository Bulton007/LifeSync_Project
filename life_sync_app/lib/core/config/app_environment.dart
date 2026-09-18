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
    this.geminiApiKey = '',
    this.geminiApiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta',
    this.geminiModel = 'gemini-2.5-flash',
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
      throw StateError('API_BASE_URL must be provided for release builds.');
    }

    const connectTimeoutSec = int.fromEnvironment(
      'API_CONNECT_TIMEOUT_SECONDS',
      defaultValue: 8,
    );
    const sendTimeoutSec = int.fromEnvironment(
      'API_SEND_TIMEOUT_SECONDS',
      defaultValue: 8,
    );
    const receiveTimeoutSec = int.fromEnvironment(
      'API_RECEIVE_TIMEOUT_SECONDS',
      defaultValue: 10,
    );

    const configuredGeminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
    const configuredGeminiBaseUrl = String.fromEnvironment(
      'GEMINI_API_BASE_URL',
      defaultValue: 'https://generativelanguage.googleapis.com/v1beta',
    );
    const configuredGeminiModel = String.fromEnvironment(
      'GEMINI_MODEL',
      defaultValue: 'gemini-2.5-flash',
    );

    String effectiveBaseUrl = selectedBaseUrl.trim().isNotEmpty
        ? selectedBaseUrl
        : _developmentBaseUrl;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final parsed = Uri.tryParse(effectiveBaseUrl.trim());
      if (parsed != null &&
          (parsed.host == 'localhost' || parsed.host == '127.0.0.1')) {
        effectiveBaseUrl = parsed.replace(host: '10.0.2.2').toString();
      }
    }

    return AppEnvironment(
      apiBaseUrl: effectiveBaseUrl,
      connectTimeout: Duration(seconds: connectTimeoutSec),
      sendTimeout: Duration(seconds: sendTimeoutSec),
      receiveTimeout: Duration(seconds: receiveTimeoutSec),
      geminiApiKey: configuredGeminiApiKey,
      geminiApiBaseUrl: configuredGeminiBaseUrl,
      geminiModel: configuredGeminiModel,
    );
  }

  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;
  final String geminiApiKey;
  final String geminiApiBaseUrl;
  final String geminiModel;

  static const _androidDevelopmentBaseUrl = 'http://10.0.2.2:8085';

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
