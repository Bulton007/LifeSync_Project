import 'package:flutter/foundation.dart';

/// Runtime configuration shared by every remote data source.
///
/// Override the development default with:
/// `--dart-define=API_BASE_URL=https://api.example.com`.
///
/// Builds default to the deployed HTTPS origin on every platform.
/// Explicit API_BASE_URL overrides must use HTTPS for release builds.
/// Do NOT include `/api` in the base URL — feature data sources already
/// prefix request paths with `/api/...`.
///
/// Android emulators can opt into the `10.0.2.2` host alias with
/// `--dart-define=ANDROID_USE_EMULATOR_ALIAS=true`. Physical devices must use
/// a reachable LAN or HTTPS origin instead.
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
        : defaultApiBaseUrl;

    if (kReleaseMode && !_isHttpsOrigin(effectiveBaseUrl)) {
      throw ArgumentError.value(
        effectiveBaseUrl,
        'API_BASE_URL',
        'Release builds must use an absolute HTTPS origin without a path.',
      );
    }

    const useAndroidEmulatorAlias = bool.fromEnvironment(
      'ANDROID_USE_EMULATOR_ALIAS',
    );

    if (!kIsWeb &&
        !kReleaseMode &&
        useAndroidEmulatorAlias &&
        defaultTargetPlatform == TargetPlatform.android) {
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

  static const defaultApiBaseUrl =
      'https://lifesync-backend-bultoncr7-dev.apps.rm3.7wse.p1.openshiftapps.com';

  static bool _isHttpsOrigin(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        uri.hasAuthority &&
        uri.scheme == 'https' &&
        _hasOriginOnlyPath(uri);
  }

  static String _normalizeAndValidate(String value) {
    final normalized = value.trim().replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.tryParse(normalized);

    if (uri == null ||
        !uri.hasAuthority ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        !_hasOriginOnlyPath(uri)) {
      throw ArgumentError.value(
        value,
        'apiBaseUrl',
        'Must be an absolute HTTP or HTTPS origin without a path.',
      );
    }

    return normalized;
  }

  static bool _hasOriginOnlyPath(Uri uri) {
    return uri.userInfo.isEmpty &&
        (uri.path.isEmpty || uri.path == '/') &&
        !uri.hasQuery &&
        !uri.hasFragment;
  }
}
