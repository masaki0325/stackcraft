import 'package:app/core/utils/error_handler.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/auth/presentation/auth_view_model.dart';
import 'package:app/features/notes/domain/note.dart';
import 'package:app/features/notes/presentation/note_edit_screen.dart';
import 'package:app/features/notes/presentation/notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/features/auth/data/auth_repository.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(notesViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ノート一覧'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(authRepositoryProvider.notifier).logout();
              if (mounted) {
                context.replace('/auth');
              }
            },
            child: const Text(
              'ログアウト',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          try {
            await ref.read(notesViewModelProvider.notifier).refreshNotes();
          } catch (e) {
            Logger.error('Failed to refresh notes', error: e);
            if (context.mounted) {
              ErrorHandler.showErrorSnackBar(
                context,
                ErrorHandler.getErrorMessage(e),
              );
            }
          }
        },
        child: notesState.when(
          data: (notes) => CustomScrollView(
            slivers: [
              if (notes.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text('ノートがありません')),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final note = notes[index];
                    return Dismissible(
                      key: Key(note.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('確認'),
                            content: const Text('このノートを削除してもよろしいですか？'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('キャンセル'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  '削除',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) async {
                        try {
                          await ref.read(notesViewModelProvider.notifier).deleteNote(note.id);
                        } catch (e) {
                          Logger.error('Failed to delete note', error: e);
                          if (context.mounted) {
                            ErrorHandler.showErrorSnackBar(
                              context,
                              ErrorHandler.getErrorMessage(e),
                            );
                            // エラーが発生した場合、リストを更新して削除をキャンセル
                            await ref.read(notesViewModelProvider.notifier).refreshNotes();
                          }
                        }
                      },
                      child: ListTile(
                        title: Text(note.title),
                        subtitle: Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          context.push('/notes/${note.id}', extra: note);
                        },
                      ),
                    );
                  }, childCount: notes.length),
                ),
            ],
          ),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ErrorHandler.getErrorMessage(error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref
                          .read(notesViewModelProvider.notifier)
                          .refreshNotes();
                    } catch (e) {
                      Logger.error('Failed to refresh notes', error: e);
                      if (context.mounted) {
                        ErrorHandler.showErrorSnackBar(
                          context,
                          ErrorHandler.getErrorMessage(e),
                        );
                      }
                    }
                  },
                  child: const Text('再試行'),
                ),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/notes/new');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
