import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final initialTitle = widget.noteFile.name?.replaceAll(RegExp(r'\.txt$'), '') ?? 'Untitled';
    _titleController.text = initialTitle;
    _loadNoteContent();
  }

  void _loadNoteContent() async {
    final content = await widget.driveService.downloadNoteContent(widget.noteFile.id!);
    _contentController.text = content;
    setState(() => _isLoading = false);
  }

  void _saveNote() async {
    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    final newTitle = _titleController.text.trim().isEmpty ? 'Untitled' : _titleController.text.trim();
    await widget.driveService.updateNote(
      widget.noteFile.id!,
      _contentController.text,
      newTitle: newTitle,
    );

    setState(() => _isSaving = false);
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note updated')),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) Navigator.pop(context);
    });
  }

  String _formatWeekday(DateTime dt) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[dt.weekday % 7];
  }

  String _formatDate(DateTime dt) {
    return '${dt.month}/${dt.day}/${dt.year}';
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timestamp = '${_formatWeekday(now)}, ${_formatDate(now)} at ${_formatTime(now)}';
    final fileName = widget.noteFile.name?.replaceAll(RegExp(r'\.txt$'), '') ?? 'Untitled';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isSaving ? null : _saveNote,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                  controller: _titleController,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
                ),
                  const SizedBox(height: 4),
                  Text(
                    '$timestamp  |  ${_contentController.text.length} characters',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Keep writing...',
                        border: InputBorder.none,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
