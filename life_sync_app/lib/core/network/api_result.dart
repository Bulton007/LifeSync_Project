import 'package:life_sync_app/core/network/api_exception.dart';

sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is ApiSuccess<T>;

  T? get dataOrNull => switch (this) {
    ApiSuccess<T>(:final data) => data,
    ApiFailure<T>() => null,
  };

  ApiException? get errorOrNull => switch (this) {
    ApiSuccess<T>() => null,
    ApiFailure<T>(:final exception) => exception,
  };

  R when<R>({
    required R Function(T data) success,
    required R Function(ApiException exception) failure,
  }) {
    return switch (this) {
      ApiSuccess<T>(:final data) => success(data),
      ApiFailure<T>(:final exception) => failure(exception),
    };
  }
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data, {this.statusCode});

  final T data;
  final int? statusCode;
}

final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.exception);

  final ApiException exception;
}
