import 'package:flutter/material.dart';
import '../services/drive_service.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class EditNoteScreen extends StatefulWidget {
  final DriveService driveService;
  final drive.File noteFile;

  const EditNoteScreen({super.key, required this.driveService, required this.noteFile});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadNoteContent();
  }

  void _loadNoteContent() async {
    final content = await widget.driveService.downloadNoteContent(widget.noteFile.id!);
    _contentController.text = content;
    setState(() => _isLoading = false);
  }

  void _saveNote() async {
    setState(() => _isSaving = true);
    await widget.driveService.updateNote(widget.noteFile.id!, _contentController.text);
    setState(() => _isSaving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.noteFile.name ?? 'Edit Note')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
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
                    child: _isSaving ? const CircularProgressIndicator() : const Text('Update Note'),
                  ),
                ],
              ),
            ),
    );
  }
}
