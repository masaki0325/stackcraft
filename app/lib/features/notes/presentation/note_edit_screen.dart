import 'package:app/core/utils/error_handler.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/notes/domain/note.dart';
import 'package:app/features/notes/presentation/note_edit_view_model.dart';
import 'package:app/features/notes/presentation/notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NoteEditScreen extends ConsumerStatefulWidget {
  final int noteId;

  const NoteEditScreen({
    super.key,
    required this.noteId,
  });

  @override
  ConsumerState<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends ConsumerState<NoteEditScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  Note? _note;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _loadNote();
  }

  Future<void> _loadNote() async {
    try {
      final notes = await ref.read(notesViewModelProvider.future);
      final note = notes.firstWhere((note) => note.id == widget.noteId);
      setState(() {
        _note = note;
        _titleController.text = note.title;
        _contentController.text = note.content;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ノートの読み込みに失敗しました: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('タイトルを入力してください')),
      );
      return;
    }

    try {
      await ref.read(notesViewModelProvider.notifier).updateNote(
            widget.noteId,
            title,
            content,
          );
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: $e'),
            action: SnackBarAction(
              label: '再試行',
              onPressed: _saveNote,
            ),
          ),
        );
      }
    }
  }

  Future<void> _deleteNote() async {
    final result = await showDialog<bool>(
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

    if (result == true) {
      try {
        await ref
            .read(notesViewModelProvider.notifier)
            .deleteNote(widget.noteId);
        if (mounted) {
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('エラーが発生しました: $e'),
              action: SnackBarAction(
                label: '再試行',
                onPressed: _deleteNote,
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ノートを編集'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteNote,
          ),
          TextButton(
            onPressed: _saveNote,
            child: const Text(
              '保存',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: _note == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'タイトル',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: '内容',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
    );
  }
}
