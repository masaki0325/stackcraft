import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/core/constants/api_constants.dart';
import 'package:app/core/utils/logger.dart';
import '../domain/note.dart';
import 'dart:async';

part 'notes_repository.g.dart';

@riverpod
class NotesRepository extends _$NotesRepository {
  @override
  FutureOr<List<Note>> build() async {
    return fetchNotes();
  }

  Future<List<Note>> fetchNotes() async {
    try {
      final response =
          await ref.read(apiClientProvider).get(ApiConstants.notes);
      return (response.data as List)
          .map((json) => Note.fromJson(json))
          .toList();
    } catch (e) {
      Logger.error('Failed to fetch notes', error: e);
      rethrow;
    }
  }

  Future<Note> getNote(int id) async {
    try {
      final response =
          await ref.read(apiClientProvider).get('${ApiConstants.notes}/$id');
      return Note.fromJson(response.data);
    } catch (e) {
      Logger.error('Failed to get note', error: e);
      rethrow;
    }
  }

  Future<Note> createNote({
    required String title,
    required String content,
  }) async {
    try {
      final response = await ref.read(apiClientProvider).post(
        ApiConstants.createNote,
        data: {
          'title': title,
          'content': content,
        },
      );
      return Note.fromJson(response.data);
    } catch (e) {
      Logger.error('Failed to create note', error: e);
      rethrow;
    }
  }

  Future<Note> updateNote(
    int id, {
    required String title,
    required String content,
  }) async {
    try {
      final response = await ref.read(apiClientProvider).put(
        ApiConstants.updateNote,
        data: {
          'id': id,
          'title': title,
          'content': content,
        },
      );
      return Note.fromJson(response.data);
    } catch (e) {
      Logger.error('Failed to update note', error: e);
      rethrow;
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await ref.read(apiClientProvider).delete('${ApiConstants.notes}/$id');
    } catch (e) {
      Logger.error('Failed to delete note', error: e);
      rethrow;
    }
  }
}
