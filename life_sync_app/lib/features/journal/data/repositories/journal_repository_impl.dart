import 'package:life_sync_app/features/journal/data/datasources/journal_local_data_source.dart';
import 'package:life_sync_app/features/journal/data/models/journal_entry.dart';
import 'package:life_sync_app/features/journal/domain/repositories/journal_repository.dart';

final class JournalRepositoryImpl implements JournalRepository {
  const JournalRepositoryImpl(this._dataSource);

  final JournalLocalDataSource _dataSource;

  @override
  Future<JournalEntry> create(JournalEntry entry) => _dataSource.create(entry);

  @override
  Future<void> delete(int id) => _dataSource.delete(id);

  @override
  Future<List<JournalEntry>> readAll() => _dataSource.readAll();

  @override
  Future<JournalEntry> update(JournalEntry entry) => _dataSource.update(entry);
}
