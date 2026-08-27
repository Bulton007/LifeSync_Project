import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/network/api_result.dart';

void main() {
  test('ApiSuccess exposes data and folds through the success branch', () {
    const result = ApiSuccess<int>(42, statusCode: 200);

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull, 42);
    expect(
      result.when(success: (data) => '$data', failure: (_) => 'failed'),
      '42',
    );
  });

  test('ApiFailure exposes its normalized exception', () {
    const exception = ApiException(
      type: ApiFailureType.server,
      message: 'Unavailable',
      statusCode: 503,
    );
    const result = ApiFailure<int>(exception);

    expect(result.isSuccess, isFalse);
    expect(result.dataOrNull, isNull);
    expect(result.errorOrNull, same(exception));
  });
}
