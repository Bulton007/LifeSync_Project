import 'package:dio/dio.dart';
import 'package:life_sync_app/core/network/api_client.dart';
import 'package:life_sync_app/core/storage/secure_token_storage.dart';
import 'package:life_sync_app/features/assistant/data/models/chat_message.dart';

final class GeminiAssistantService {
  GeminiAssistantService(
    this._secureStore, {
    this.apiClient,
    this.defaultApiKey,
    String? apiBaseUrl,
    String? preferredModel,
  }) : _apiBase = _normalizeBaseUrl(
         apiBaseUrl != null && apiBaseUrl.trim().isNotEmpty
             ? apiBaseUrl
             : const String.fromEnvironment(
                 'GEMINI_API_BASE_URL',
                 defaultValue:
                     'https://generativelanguage.googleapis.com/v1beta',
               ),
       ),
       _preferredModel =
           preferredModel != null && preferredModel.trim().isNotEmpty
           ? preferredModel.trim()
           : const String.fromEnvironment(
               'GEMINI_MODEL',
               defaultValue: 'gemini-3.6-flash',
             ),
       _dio = Dio(
         BaseOptions(
           connectTimeout: const Duration(
             seconds: int.fromEnvironment(
               'GEMINI_CONNECT_TIMEOUT_SECONDS',
               defaultValue: 45,
             ),
           ),
           receiveTimeout: const Duration(
             seconds: int.fromEnvironment(
               'GEMINI_RECEIVE_TIMEOUT_SECONDS',
               defaultValue: 60,
             ),
           ),
           sendTimeout: const Duration(
             seconds: int.fromEnvironment(
               'GEMINI_SEND_TIMEOUT_SECONDS',
               defaultValue: 45,
             ),
           ),
           headers: {'Content-Type': 'application/json'},
         ),
       );

  static const _apiKeyStorageKey = 'gemini.api_key';
  final String _apiBase;
  final String _preferredModel;

  final SecureKeyValueStore _secureStore;
  final ApiClient? apiClient;
  final Dio _dio;
  final String? defaultApiKey;
  String? _resolvedModel;
  String? _inMemoryApiKey;
  bool _explicitlyCleared = false;

  static String _normalizeBaseUrl(String url) {
    return url.trim().replaceAll(RegExp(r'/+$'), '');
  }

  Future<String?> getApiKey() async {
    if (_explicitlyCleared) return null;

    if (apiClient != null) {
      return '__BACKEND_MANAGED__';
    }

    if (_inMemoryApiKey != null && _inMemoryApiKey!.isNotEmpty) {
      return _inMemoryApiKey;
    }
    try {
      final storedKey = await _secureStore.read(_apiKeyStorageKey);
      if (storedKey != null && storedKey.trim().isNotEmpty) {
        _inMemoryApiKey = _cleanKey(storedKey);
        return _inMemoryApiKey;
      }
    } catch (_) {}

    final defaultKey = defaultApiKey;
    if (defaultKey != null && defaultKey.trim().isNotEmpty) {
      _inMemoryApiKey = _cleanKey(defaultKey);
      return _inMemoryApiKey;
    }

    const envKey = String.fromEnvironment('GEMINI_API_KEY');
    if (envKey.trim().isNotEmpty) {
      _inMemoryApiKey = _cleanKey(envKey);
      return _inMemoryApiKey;
    }

    return null;
  }

  static String _cleanKey(String key) {
    return key.trim().replaceAll('"', '').replaceAll("'", '');
  }

  Future<void> saveApiKey(String apiKey) async {
    _explicitlyCleared = false;
    _resolvedModel = null;
    final cleaned = _cleanKey(apiKey);
    _inMemoryApiKey = cleaned;
    try {
      await _secureStore.write(_apiKeyStorageKey, cleaned);
    } catch (_) {}
  }

  Future<void> clearApiKey() async {
    _explicitlyCleared = true;
    _resolvedModel = null;
    _inMemoryApiKey = null;
    try {
      await _secureStore.delete(_apiKeyStorageKey);
    } catch (_) {}
  }

  /// Discovers which Gemini models are available for this specific API key.
  Future<String> _getOrResolveModel(String apiKey) async {
    if (_resolvedModel != null) return _resolvedModel!;

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_apiBase/models',
        options: Options(headers: {'x-goog-api-key': apiKey}),
      );
      final rawModels = response.data?['models'] as List<dynamic>? ?? [];
      final available = rawModels
          .whereType<Map<String, dynamic>>()
          .where((m) {
            final methods =
                (m['supportedGenerationMethods'] as List<dynamic>?) ?? [];
            return methods.contains('generateContent');
          })
          .map((m) => (m['name'] as String?)?.replaceFirst('models/', '') ?? '')
          .where((name) => name.isNotEmpty)
          .toSet();

      final candidatePreferences = [
        _preferredModel,
        'gemini-3.6-flash',
        'gemini-flash-latest',
        'gemini-2.5-flash-lite',
        'gemini-3.5-flash',
        'gemini-3.5-flash-lite',
      ];

      for (final candidate in candidatePreferences) {
        if (available.contains(candidate)) {
          _resolvedModel = candidate;
          return candidate;
        }
      }

      if (available.isNotEmpty) {
        final anyFlash = available.firstWhere(
          (m) => m.contains('flash'),
          orElse: () => available.first,
        );
        _resolvedModel = anyFlash;
        return anyFlash;
      }
    } catch (_) {
      // Fall back if list query fails
    }

    _resolvedModel = 'gemini-3.5-flash-lite';
    return _resolvedModel!;
  }

  Future<String> sendMessage({
    required String prompt,
    required List<ChatMessage> conversationHistory,
  }) async {
    final apiKey = await getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw StateError('NO_API_KEY');
    }

    final client = apiClient;
    if (client != null && apiKey == '__BACKEND_MANAGED__') {
      final historyPayload = conversationHistory
          .where((m) => !m.isError && m.sender != MessageSender.system)
          .map(
            (m) => {
              'role': m.sender == MessageSender.user ? 'user' : 'model',
              'text': m.text,
            },
          )
          .toList(growable: false);

      final result = await client.post<Map<String, dynamic>>(
        '/api/assistant/chat',
        data: {'prompt': prompt, 'history': historyPayload},
        decoder: (data) =>
            data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      return result.when(
        success: (data) {
          final reply = data['reply'] as String?;
          if (reply != null && reply.trim().isNotEmpty) {
            return reply.trim();
          }
          throw Exception('Received empty response from assistant.');
        },
        failure: (error) => throw Exception(error.message),
      );
    }

    final contents = <Map<String, dynamic>>[];

    final historyToInclude = conversationHistory
        .where((m) => !m.isError && m.sender != MessageSender.system)
        .toList();

    final recentHistory = historyToInclude.length > 8
        ? historyToInclude.sublist(historyToInclude.length - 8)
        : historyToInclude;

    for (final message in recentHistory) {
      contents.add({
        'role': message.sender == MessageSender.user ? 'user' : 'model',
        'parts': [
          {'text': message.text},
        ],
      });
    }

    contents.add({
      'role': 'user',
      'parts': [
        {'text': prompt},
      ],
    });

    final payload = {
      'system_instruction': {
        'parts': [
          {
            'text':
                'You are LifeSync AI, a friendly, encouraging, and intelligent personal productivity companion for the LifeSync app. '
                'You help users organize tasks, build positive habits, achieve goals, manage budget/finances, and practice mindful journaling. '
                'Keep your answers concise, practical, engaging, and clear. Format responses with neat bullet points or short paragraphs where appropriate.',
          },
        ],
      },
      'contents': contents,
      'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 1024},
    };

    final resolved = await _getOrResolveModel(apiKey);
    final candidateModels = [
      resolved,
      _preferredModel,
      'gemini-3.5-flash-lite',
      'gemini-2.5-flash',
      'gemini-2.0-flash',
    ];

    DioException? lastDioError;
    final tried = <String>{};

    for (final model in candidateModels) {
      if (tried.contains(model)) continue;
      tried.add(model);

      try {
        final url = '$_apiBase/models/$model:generateContent';
        final response = await _dio.post<Map<String, dynamic>>(
          url,
          data: payload,
          options: Options(headers: {'x-goog-api-key': apiKey}),
        );

        final data = response.data;
        if (data == null) {
          throw Exception('Empty response received from Gemini.');
        }

        final candidates = data['candidates'] as List<dynamic>?;
        if (candidates == null || candidates.isEmpty) {
          throw Exception(
            'No response generated by Gemini. Prompt may have been filtered.',
          );
        }

        final firstCandidate = candidates.first as Map<String, dynamic>;
        final content = firstCandidate['content'] as Map<String, dynamic>?;
        final parts = content?['parts'] as List<dynamic>?;

        if (parts == null || parts.isEmpty) {
          throw Exception('Empty content returned by AI.');
        }

        _resolvedModel = model;
        final text = parts.first['text'] as String?;
        return text?.trim() ?? 'No response text generated.';
      } on DioException catch (e) {
        lastDioError = e;
        if (model == _resolvedModel) {
          _resolvedModel = null;
        }
        if (e.response?.statusCode == 404) {
          continue;
        }
        _handleDioError(e);
      }
    }

    if (lastDioError != null) {
      _handleDioError(lastDioError);
    }

    throw Exception(
      'Failed to generate response. Please check your network connection and API key.',
    );
  }

  Never _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception(
        'Connection timed out (45s). If you are testing in a region where Google endpoints are restricted, enable a VPN.',
      );
    }

    final status = e.response?.statusCode;
    final rawError = e.response?.data;
    String? message;

    if (rawError is Map<String, dynamic>) {
      message = rawError['error']?['message'] as String?;
    }

    if (status == 400 || status == 403) {
      throw Exception(
        'Gemini API Error ($status): ${message ?? 'Invalid API key or unauthorized request.'}',
      );
    } else if (status == 404) {
      throw Exception(
        'Gemini API Error (404): ${message ?? 'The requested model was not found.'}'
            .trim(),
      );
    } else if (status == 429) {
      throw Exception(
        'Gemini rate limit exceeded. Please wait a moment before sending another prompt.',
      );
    }

    throw Exception(
      message ?? e.message ?? 'Network error connecting to Gemini API.',
    );
  }
}
