import 'package:life_sync_app/core/database/life_sync_database.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';
import 'package:life_sync_app/features/journal/data/models/journal_entry.dart';
import 'package:sqflite/sqflite.dart';

final class JournalLocalDataSource {
  const JournalLocalDataSource(this._database, this._sessionService);

  final LifeSyncDatabase _database;
  final AuthSessionService _sessionService;

  int get _ownerId =>
      _sessionService.currentSession?.userId ??
      (throw StateError('A signed-in user is required for local journals.'));

  Future<List<JournalEntry>> readAll() async {
    final database = await _database.database;
    final rows = await database.query(
      'journal_entries',
      where: 'owner_id = ?',
      whereArgs: [_ownerId],
      orderBy: 'created_at DESC',
    );
    return rows.map(JournalEntry.fromDatabase).toList(growable: false);
  }

  Future<JournalEntry> create(JournalEntry entry) async {
    final database = await _database.database;
    final id = await database.insert('journal_entries', {
      ...entry.toDatabase(),
      'owner_id': _ownerId,
    }, conflictAlgorithm: ConflictAlgorithm.abort);
    return entry.copyWith(id: id);
  }

  Future<JournalEntry> update(JournalEntry entry) async {
    final id = entry.id;
    if (id == null) throw ArgumentError('A journal id is required to update.');
    final database = await _database.database;
    final changed = await database.update(
      'journal_entries',
      entry.toDatabase()..remove('id'),
      where: 'id = ? AND owner_id = ?',
      whereArgs: [id, _ownerId],
    );
    if (changed != 1) throw StateError('Journal entry $id was not found.');
    return entry;
  }

  Future<void> delete(int id) async {
    final database = await _database.database;
    await database.delete(
      'journal_entries',
      where: 'id = ? AND owner_id = ?',
      whereArgs: [id, _ownerId],
    );
  }
}
