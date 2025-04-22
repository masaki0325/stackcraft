import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/features/auth/presentation/auth_screen.dart';
import 'package:app/features/notes/presentation/notes_screen.dart';
import 'package:app/features/notes/presentation/note_create_screen.dart';
import 'package:app/features/notes/presentation/note_edit_screen.dart';
import 'package:app/features/notes/domain/note.dart';
import 'package:app/features/notes/presentation/notes_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(path: '/', builder: (context, state) => const NotesScreen()),
    GoRoute(
      path: '/notes/new',
      builder: (context, state) => const NoteCreateScreen(),
    ),
    GoRoute(
      path: '/notes/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return NoteEditScreen(noteId: id);
      },
    ),
  ],
);
