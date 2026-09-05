import 'dart:convert';
import 'package:dio/dio.dart';

enum ApiFailureType {
  network,
  timeout,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  server,
  cancelled,
  serialization,
  unknown,
}

/// A stable, UI-safe error contract for every feature repository.
final class ApiException implements Exception {
  const ApiException({
    required this.type,
    required this.message,
    this.statusCode,
    this.cause,
  });

  factory ApiException.fromDioException(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => ApiException(
        type: ApiFailureType.timeout,
        message: 'The request timed out. Please try again.',
        cause: exception,
      ),
      DioExceptionType.connectionError ||
      DioExceptionType.badCertificate => ApiException(
        type: ApiFailureType.network,
        message: 'Unable to reach the server. Check your connection.',
        cause: exception,
      ),
      DioExceptionType.cancel => ApiException(
        type: ApiFailureType.cancelled,
        message: 'The request was cancelled.',
        cause: exception,
      ),
      DioExceptionType.badResponse => _fromResponse(exception),
      DioExceptionType.unknown => ApiException(
        type: ApiFailureType.unknown,
        message: 'Something went wrong. Please try again.',
        cause: exception,
      ),
    };
  }

  final ApiFailureType type;
  final String message;
  final int? statusCode;
  final Object? cause;

  bool get isUnauthorized => type == ApiFailureType.unauthorized;

  static ApiException _fromResponse(DioException exception) {
    final response = exception.response;
    final statusCode = response?.statusCode;
    final serverMessage = _extractMessage(response?.data);
    final type = switch (statusCode) {
      400 => ApiFailureType.badRequest,
      401 => ApiFailureType.unauthorized,
      403 => ApiFailureType.forbidden,
      404 => ApiFailureType.notFound,
      409 => ApiFailureType.conflict,
      422 => ApiFailureType.validation,
      int code when code >= 500 && code <= 599 => ApiFailureType.server,
      _ => ApiFailureType.unknown,
    };

    return ApiException(
      type: type,
      statusCode: statusCode,
      message: serverMessage ?? _fallbackMessage(type),
      cause: exception,
    );
  }

  static String? _extractMessage(Object? data) {
    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return null;
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map<Object?, Object?>) {
          final message = decoded['message'];
          if (message is String && message.trim().isNotEmpty) {
            return message.trim();
          }
          final error = decoded['error'];
          if (error is String && error.trim().isNotEmpty) {
            return error.trim();
          }
        }
      } catch (_) {
        // Not a JSON string; return trimmed string
      }
      return trimmed;
    }

    if (data is Map<Object?, Object?>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      final error = data['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }
    }

    return null;
  }

  static String _fallbackMessage(ApiFailureType type) {
    return switch (type) {
      ApiFailureType.badRequest => 'The request could not be completed.',
      ApiFailureType.unauthorized => 'Your session has expired. Sign in again.',
      ApiFailureType.forbidden =>
        'You do not have permission to perform this action.',
      ApiFailureType.notFound => 'The requested item could not be found.',
      ApiFailureType.conflict => 'This change conflicts with the current data.',
      ApiFailureType.validation => 'Please check the submitted information.',
      ApiFailureType.server => 'The server could not complete the request.',
      _ => 'Something went wrong. Please try again.',
    };
  }

  @override
  String toString() {
    final status = statusCode == null ? '' : ' ($statusCode)';
    return 'ApiException$status: $message';
  }
}
