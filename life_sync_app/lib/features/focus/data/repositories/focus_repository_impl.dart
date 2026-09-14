import 'package:life_sync_app/features/focus/data/datasources/focus_local_data_source.dart';
import 'package:life_sync_app/features/focus/data/models/focus_session.dart';
import 'package:life_sync_app/features/focus/domain/repositories/focus_repository.dart';

final class FocusRepositoryImpl implements FocusRepository {
  const FocusRepositoryImpl(this._dataSource);

  final FocusLocalDataSource _dataSource;

  @override
  Future<FocusSession> create(FocusSession session) =>
      _dataSource.create(session);

  @override
  Future<List<FocusSession>> readAll() => _dataSource.readAll();
}
