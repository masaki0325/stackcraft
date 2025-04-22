import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/features/notes/data/notes_repository.dart';
import 'package:app/features/notes/domain/note.dart';
import 'package:app/core/utils/logger.dart';
import 'dart:async';

part 'note_edit_view_model.g.dart';

@riverpod
class NoteEditViewModel extends _$NoteEditViewModel {
  @override
  FutureOr<Note?> build() async {
    return null;
  }

  Future<void> loadNote(int noteId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(notesRepositoryProvider.notifier).getNote(noteId);
    });
  }

  Future<void> createNote({
    required String title,
    required String content,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(notesRepositoryProvider.notifier).createNote(
            title: title,
            content: content,
          );
    });
  }

  Future<void> updateNote(
    int id, {
    required String title,
    required String content,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(notesRepositoryProvider.notifier).updateNote(
            id,
            title: title,
            content: content,
          );
    });
  }
}
