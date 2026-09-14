import 'package:sqflite/sqflite.dart';

final class LifeSyncDatabase {
  LifeSyncDatabase({Future<Database> Function()? openDatabase})
    : _openDatabaseOverride = openDatabase;

  final Future<Database> Function()? _openDatabaseOverride;
  Database? _database;

  Future<Database> get database async {
    final cached = _database;
    if (cached != null) return cached;
    final opened = _openDatabaseOverride == null
        ? await _open()
        : await _openDatabaseOverride();
    _database = opened;
    return opened;
  }

  Future<Database> _open() async {
    final root = await getDatabasesPath();
    return openDatabase(
      '$root/lifesync_local.db',
      version: 2,
      onConfigure: (database) => database.execute('PRAGMA foreign_keys = ON'),
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE journal_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            owner_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            body TEXT NOT NULL,
            tags_json TEXT NOT NULL,
            attachments_json TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
        await database.execute('''
          CREATE TABLE focus_sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            owner_id INTEGER NOT NULL,
            mode TEXT NOT NULL,
            task_name TEXT,
            started_at TEXT NOT NULL,
            duration_seconds INTEGER NOT NULL,
            completed INTEGER NOT NULL
          )
        ''');
        await database.execute(
          'CREATE INDEX journal_created_at ON journal_entries(created_at)',
        );
        await database.execute(
          'CREATE INDEX focus_started_at ON focus_sessions(started_at)',
        );
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await database.execute(
            'ALTER TABLE journal_entries ADD COLUMN owner_id INTEGER NOT NULL DEFAULT 0',
          );
          await database.execute(
            'ALTER TABLE focus_sessions ADD COLUMN owner_id INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );
  }

  Future<void> close() async {
    final database = _database;
    _database = null;
    await database?.close();
  }
}
