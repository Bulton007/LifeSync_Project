import 'package:get/get.dart';
import 'package:life_sync_app/features/journal/data/models/journal_entry.dart';
import 'package:life_sync_app/features/journal/domain/repositories/journal_repository.dart';

final class JournalController extends GetxController {
  JournalController(this._repository);

  final JournalRepository _repository;
  final entries = <JournalEntry>[].obs;
  final selectedDate = DateTime.now().obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = RxnString();

  List<JournalEntry> get visibleEntries {
    final query = searchQuery.value.trim().toLowerCase();
    final date = selectedDate.value;
    return entries
        .where((entry) {
          final sameDay =
              entry.createdAt.year == date.year &&
              entry.createdAt.month == date.month &&
              entry.createdAt.day == date.day;
          final matches =
              query.isEmpty ||
              entry.title.toLowerCase().contains(query) ||
              entry.body.toLowerCase().contains(query) ||
              entry.tags.any((tag) => tag.toLowerCase().contains(query));
          return sameDay && matches;
        })
        .toList(growable: false);
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      entries.assignAll(await _repository.readAll());
    } on Object catch (error) {
      errorMessage.value = 'Journal could not be loaded: $error';
    } finally {
      isLoading.value = false;
    }
  }

  void selectDate(DateTime value) {
    selectedDate.value = DateTime(value.year, value.month, value.day);
  }

  Future<bool> save(JournalEntry entry) async {
    if (isSubmitting.value) return false;
    if (entry.title.trim().isEmpty || entry.body.trim().isEmpty) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      final normalized = entry.copyWith(
        title: entry.title.trim(),
        body: entry.body.trim(),
        updatedAt: DateTime.now(),
      );
      final saved = normalized.id == null
          ? await _repository.create(normalized)
          : await _repository.update(normalized);
      final index = entries.indexWhere((item) => item.id == saved.id);
      if (index == -1) {
        entries.insert(0, saved);
      } else {
        entries[index] = saved;
      }
      entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      entries.refresh();
      selectDate(saved.createdAt);
      return true;
    } on Object catch (error) {
      errorMessage.value = 'Journal could not be saved: $error';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> delete(JournalEntry entry) async {
    final id = entry.id;
    if (id == null || isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = null;
    try {
      await _repository.delete(id);
      entries.removeWhere((item) => item.id == id);
      return true;
    } on Object catch (error) {
      errorMessage.value = 'Journal could not be deleted: $error';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
