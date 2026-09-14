import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/features/journal/data/models/journal_entry.dart';
import 'package:life_sync_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:life_sync_app/features/journal/presentation/controllers/journal_controller.dart';

void main() {
  test(
    'creates, updates, filters, deletes, and reloads persisted entries',
    () async {
      final repository = _MemoryJournalRepository();
      final controller = JournalController(repository);
      final createdAt = DateTime(2026, 9, 11, 19, 30);

      final saved = await controller.save(
        JournalEntry(
          id: null,
          title: 'Night Time',
          body: 'A quiet walk through the city.',
          createdAt: createdAt,
          updatedAt: createdAt,
          tags: const ['reflection'],
          attachments: const ['aW1hZ2U='],
        ),
      );
      expect(saved, isTrue);
      expect(controller.entries, hasLength(1));

      controller.selectDate(createdAt);
      controller.searchQuery.value = 'quiet';
      expect(controller.visibleEntries.single.title, 'Night Time');
      controller.searchQuery.value = 'missing';
      expect(controller.visibleEntries, isEmpty);

      final existing = controller.entries.single;
      expect(
        await controller.save(existing.copyWith(title: 'Updated memory')),
        isTrue,
      );
      expect(controller.entries.single.title, 'Updated memory');

      final restored = JournalController(repository);
      await restored.load();
      expect(restored.entries.single.attachments, const ['aW1hZ2U=']);

      expect(await restored.delete(restored.entries.single), isTrue);
      expect(await repository.readAll(), isEmpty);
    },
  );

  test('rejects empty title or body without touching persistence', () async {
    final repository = _MemoryJournalRepository();
    final controller = JournalController(repository);
    final now = DateTime(2026, 9, 11);
    expect(
      await controller.save(
        JournalEntry(
          id: null,
          title: ' ',
          body: 'Body',
          createdAt: now,
          updatedAt: now,
        ),
      ),
      isFalse,
    );
    expect(await repository.readAll(), isEmpty);
  });
}

final class _MemoryJournalRepository implements JournalRepository {
  final _entries = <JournalEntry>[];
  int _nextId = 1;

  @override
  Future<JournalEntry> create(JournalEntry entry) async {
    final saved = entry.copyWith(id: _nextId++);
    _entries.add(saved);
    return saved;
  }

  @override
  Future<void> delete(int id) async =>
      _entries.removeWhere((entry) => entry.id == id);

  @override
  Future<List<JournalEntry>> readAll() async => List.of(_entries);

  @override
  Future<JournalEntry> update(JournalEntry entry) async {
    final index = _entries.indexWhere((item) => item.id == entry.id);
    _entries[index] = entry;
    return entry;
  }
}
