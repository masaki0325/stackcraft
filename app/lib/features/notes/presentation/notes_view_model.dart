import 'package:app/core/utils/logger.dart';
import 'package:app/features/notes/data/notes_repository.dart';
import 'package:app/features/notes/domain/note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';

part 'notes_view_model.g.dart';

@riverpod
class NotesViewModel extends _$NotesViewModel {
  @override
  Future<List<Note>> build() async {
    return ref.read(notesRepositoryProvider.notifier).fetchNotes();
  }

  Future<void> refreshNotes() async {
    ref.invalidateSelf();
  }

  Future<void> createNote(String title, String content) async {
    await ref.read(notesRepositoryProvider.notifier).createNote(
          title: title,
          content: content,
        );
    ref.invalidateSelf();
  }

  Future<void> updateNote(int id, String title, String content) async {
    await ref.read(notesRepositoryProvider.notifier).updateNote(
          id,
          title: title,
          content: content,
        );
    ref.invalidateSelf();
  }

  Future<void> deleteNote(int id) async {
    try {
      await ref.read(notesRepositoryProvider.notifier).deleteNote(id);
      // 現在のノートリストから削除したノートを除外
      state = AsyncValue.data(
          state.value?.where((note) => note.id != id).toList() ?? []
      );
    } catch (e) {
      Logger.error('Failed to delete note', error: e);
      rethrow;
    }
  }
}
