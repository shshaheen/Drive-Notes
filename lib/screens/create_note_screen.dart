import 'package:flutter/material.dart';
import '../services/drive_service.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class CreateNoteScreen extends StatefulWidget {
  final DriveService driveService;

  const CreateNoteScreen({super.key, required this.driveService});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isSaving = false;

  void _saveNote() async {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) return;

    setState(() => _isSaving = true);

    await widget.driveService.uploadNote(
      _contentController.text,
      _titleController.text.trim(),
    );

    setState(() => _isSaving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Note')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Note Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: 'Note Content',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveNote,
              child: _isSaving ? const CircularProgressIndicator() : const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}