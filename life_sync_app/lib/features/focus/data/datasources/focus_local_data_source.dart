import 'package:life_sync_app/core/database/life_sync_database.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/features/focus/data/models/focus_session.dart';

final class FocusLocalDataSource {
  const FocusLocalDataSource(this._database, this._sessionService);

  final LifeSyncDatabase _database;
  final AuthSessionService _sessionService;

  int get _ownerId => _sessionService.currentSession?.userId ?? 0;

  Future<List<FocusSession>> readAll() async {
    final database = await _database.database;
    final rows = await database.query(
      'focus_sessions',
      where: 'owner_id = ?',
      whereArgs: [_ownerId],
      orderBy: 'started_at DESC',
    );
    return rows.map(FocusSession.fromDatabase).toList(growable: false);
  }

  Future<FocusSession> create(FocusSession session) async {
    final database = await _database.database;
    final id = await database.insert('focus_sessions', {
      ...session.toDatabase(),
      'owner_id': _ownerId,
    });
    return session.copyWith(id: id);
  }
}
