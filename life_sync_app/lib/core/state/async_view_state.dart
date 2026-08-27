import 'package:life_sync_app/core/network/api_exception.dart';

enum ViewStatus { initial, loading, refreshing, success, empty, error }

/// Immutable state shared by feature controllers.
final class AsyncViewState<T> {
  const AsyncViewState._({required this.status, this.data, this.exception});

  const AsyncViewState.initial() : this._(status: ViewStatus.initial);

  const AsyncViewState.loading() : this._(status: ViewStatus.loading);

  const AsyncViewState.refreshing(T currentData)
    : this._(status: ViewStatus.refreshing, data: currentData);

  const AsyncViewState.success(T data)
    : this._(status: ViewStatus.success, data: data);

  const AsyncViewState.empty() : this._(status: ViewStatus.empty);

  const AsyncViewState.error(ApiException exception, {T? previousData})
    : this._(
        status: ViewStatus.error,
        data: previousData,
        exception: exception,
      );

  final ViewStatus status;
  final T? data;
  final ApiException? exception;

  bool get isBusy =>
      status == ViewStatus.loading || status == ViewStatus.refreshing;
}
