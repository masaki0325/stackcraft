import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/features/notes/presentation/notes_view_model.dart';
import 'package:app/core/utils/error_handler.dart';

class NoteCreateScreen extends ConsumerStatefulWidget {
  const NoteCreateScreen({super.key});

  @override
  ConsumerState<NoteCreateScreen> createState() => _NoteCreateScreenState();
}

class _NoteCreateScreenState extends ConsumerState<NoteCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(notesViewModelProvider.notifier).createNote(
              _titleController.text,
              _contentController.text,
            );
        if (mounted) {
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('エラー'),
              content: Text(ErrorHandler.getErrorMessage(e)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
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
        title: const Text('新規ノート'),
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: const Text(
              '保存',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'タイトル',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'タイトルを入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: '内容',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '内容を入力してください';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
