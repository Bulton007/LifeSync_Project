import 'package:life_sync_app/features/journal/data/models/journal_entry.dart';

abstract interface class JournalRepository {
  Future<List<JournalEntry>> readAll();

  Future<JournalEntry> create(JournalEntry entry);

  Future<JournalEntry> update(JournalEntry entry);

  Future<void> delete(int id);
}
