import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/network/api_exception.dart';
import 'package:life_sync_app/core/state/async_view_state.dart';

void main() {
  test('refreshing retains current data and is busy', () {
    const state = AsyncViewState<List<int>>.refreshing([1, 2]);

    expect(state.status, ViewStatus.refreshing);
    expect(state.data, [1, 2]);
    expect(state.isBusy, isTrue);
  });

  test('error can retain stale data for non-destructive rendering', () {
    const exception = ApiException(
      type: ApiFailureType.network,
      message: 'Offline',
    );
    const state = AsyncViewState<List<int>>.error(exception, previousData: [1]);

    expect(state.status, ViewStatus.error);
    expect(state.data, [1]);
    expect(state.exception, same(exception));
  });
}
