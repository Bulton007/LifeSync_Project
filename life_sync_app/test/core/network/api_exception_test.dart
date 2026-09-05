import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/network/api_exception.dart';

void main() {
  group('ApiException', () {
    test('uses the backend message for application errors', () {
      final request = RequestOptions(path: '/api/tasks');
      final error = DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response<Object?>(
          requestOptions: request,
          statusCode: 409,
          data: const {'message': 'Task already exists'},
        ),
      );

      final exception = ApiException.fromDioException(error);

      expect(exception.type, ApiFailureType.conflict);
      expect(exception.statusCode, 409);
      expect(exception.message, 'Task already exists');
    });

    test('extracts clean message from raw JSON string response', () {
      final request = RequestOptions(path: '/api/auth/login');
      final error = DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response<Object?>(
          requestOptions: request,
          statusCode: 404,
          data: '{"success":false,"message":"email not found","status":404}',
        ),
      );

      final exception = ApiException.fromDioException(error);

      expect(exception.type, ApiFailureType.notFound);
      expect(exception.statusCode, 404);
      expect(exception.message, 'email not found');
    });

    test('normalizes JWT entry-point errors', () {
      final request = RequestOptions(path: '/api/tasks');
      final error = DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response<Object?>(
          requestOptions: request,
          statusCode: 401,
          data: const {
            'error': 'Unauthorized',
            'message': 'JWT token is expired',
          },
        ),
      );

      final exception = ApiException.fromDioException(error);

      expect(exception.type, ApiFailureType.unauthorized);
      expect(exception.message, 'JWT token is expired');
      expect(exception.isUnauthorized, isTrue);
    });

    test('normalizes connection timeouts', () {
      final exception = ApiException.fromDioException(
        DioException(
          requestOptions: RequestOptions(path: '/api/tasks'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(exception.type, ApiFailureType.timeout);
      expect(exception.message, contains('timed out'));
    });
  });
}
