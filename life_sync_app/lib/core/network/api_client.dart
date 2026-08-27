import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:life_sync_app/core/config/app_environment.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/network/api_result.dart';
import 'package:life_sync_app/core/network/auth_interceptor.dart';
import 'package:life_sync_app/core/storage/token_storage.dart';

typedef ApiDecoder<T> = T Function(Object? data);

/// The only low-level HTTP dependency exposed to feature data sources.
final class ApiClient {
  ApiClient({
    required AppEnvironment environment,
    required TokenStorage tokenStorage,
    required UnauthorizedCallback onUnauthorized,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: environment.apiBaseUrl,
      connectTimeout: environment.connectTimeout,
      sendTimeout: environment.sendTimeout,
      receiveTimeout: environment.receiveTimeout,
      responseType: ResponseType.json,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _dio.interceptors.add(AuthInterceptor(tokenStorage, onUnauthorized));

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false,
          error: true,
          logPrint: (message) => debugPrint(message.toString()),
        ),
      );
    }
  }

  final Dio _dio;

  Future<ApiResult<T>> get<T>(
    String path, {
    required ApiDecoder<T> decoder,
    Map<String, dynamic>? queryParameters,
    bool skipAuthentication = false,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'GET',
      decoder: decoder,
      queryParameters: queryParameters,
      skipAuthentication: skipAuthentication,
      cancelToken: cancelToken,
    );
  }

  Future<ApiResult<Uint8List>> getBytes(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool skipAuthentication = false,
    CancelToken? cancelToken,
  }) {
    return request<Uint8List>(
      path,
      method: 'GET',
      decoder: (data) {
        if (data is Uint8List) return data;
        if (data is List<int>) return Uint8List.fromList(data);
        throw const FormatException('Expected a binary response.');
      },
      queryParameters: queryParameters,
      skipAuthentication: skipAuthentication,
      cancelToken: cancelToken,
      responseType: ResponseType.bytes,
    );
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    required ApiDecoder<T> decoder,
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool skipAuthentication = false,
    ResponseType? responseType,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'POST',
      decoder: decoder,
      data: data,
      queryParameters: queryParameters,
      skipAuthentication: skipAuthentication,
      responseType: responseType,
      cancelToken: cancelToken,
    );
  }

  Future<ApiResult<T>> put<T>(
    String path, {
    required ApiDecoder<T> decoder,
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool skipAuthentication = false,
    ResponseType? responseType,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'PUT',
      decoder: decoder,
      data: data,
      queryParameters: queryParameters,
      skipAuthentication: skipAuthentication,
      responseType: responseType,
      cancelToken: cancelToken,
    );
  }

  Future<ApiResult<T>> patch<T>(
    String path, {
    required ApiDecoder<T> decoder,
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool skipAuthentication = false,
    ResponseType? responseType,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'PATCH',
      decoder: decoder,
      data: data,
      queryParameters: queryParameters,
      skipAuthentication: skipAuthentication,
      responseType: responseType,
      cancelToken: cancelToken,
    );
  }

  Future<ApiResult<T>> delete<T>(
    String path, {
    required ApiDecoder<T> decoder,
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool skipAuthentication = false,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'DELETE',
      decoder: decoder,
      data: data,
      queryParameters: queryParameters,
      skipAuthentication: skipAuthentication,
      cancelToken: cancelToken,
    );
  }

  Future<ApiResult<T>> uploadFile<T>(
    String path, {
    required String filePath,
    required ApiDecoder<T> decoder,
    String fieldName = 'file',
    String? fileName,
    Map<String, dynamic> fields = const {},
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final file = await MultipartFile.fromFile(filePath, filename: fileName);
      final formData = FormData.fromMap({...fields, fieldName: file});

      return request<T>(
        path,
        method: 'POST',
        decoder: decoder,
        data: formData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        contentType: Headers.multipartFormDataContentType,
      );
    } on Object catch (error) {
      return ApiFailure<T>(
        ApiException(
          type: ApiFailureType.unknown,
          message: 'The selected file could not be prepared for upload.',
          cause: error,
        ),
      );
    }
  }

  Future<ApiResult<T>> request<T>(
    String path, {
    required String method,
    required ApiDecoder<T> decoder,
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool skipAuthentication = false,
    String? contentType,
    ResponseType? responseType,
    CancelToken? cancelToken,
  }) async {
    try {
      final effectiveResponseType =
          responseType ?? (T == String ? ResponseType.plain : null);
      final options = Options(
        method: method,
        contentType: contentType,
        extra: {AuthInterceptor.skipAuthenticationKey: skipAuthentication},
      );
      if (effectiveResponseType != null) {
        options.responseType = effectiveResponseType;
      }

      final response = effectiveResponseType == ResponseType.plain
          ? await _dio.request<String>(
              path,
              data: data,
              queryParameters: queryParameters,
              cancelToken: cancelToken,
              options: options,
            )
          : await _dio.request<Object?>(
              path,
              data: data,
              queryParameters: queryParameters,
              cancelToken: cancelToken,
              options: options,
            );

      return ApiSuccess<T>(
        decoder(response.data),
        statusCode: response.statusCode,
      );
    } on DioException catch (error) {
      return ApiFailure<T>(ApiException.fromDioException(error));
    } on Object catch (error) {
      return ApiFailure<T>(
        ApiException(
          type: ApiFailureType.serialization,
          message: 'The server returned an unexpected response.',
          cause: error,
        ),
      );
    }
  }
}
