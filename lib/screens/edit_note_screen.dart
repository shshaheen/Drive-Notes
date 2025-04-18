import 'package:drive_notes/models/note_file.dart';
import 'package:drive_notes/providers/file_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:googleapis/drive/v3.dart' as drive;

class EditNoteScreen extends ConsumerStatefulWidget {
  final NoteFile noteFile;

  const EditNoteScreen({super.key, required this.noteFile});

  @override
  ConsumerState<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends ConsumerState<EditNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final initialTitle = widget.noteFile.name.replaceAll(RegExp(r'\.txt$'), '') ?? 'Untitled';
    _titleController.text = initialTitle;
    _loadNoteContent();
  }

  void _loadNoteContent() async {
    final driveService = ref.read(driveFilesProvider.notifier).driveService;
    final content = await driveService.downloadNoteContent(widget.noteFile.id);
    _contentController.text = content;
    setState(() => _isLoading = false);
  }

  void _saveNote() async {
    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    final driveService = ref.read(driveFilesProvider.notifier).driveService;
    final newTitle = _titleController.text.trim().isEmpty ? 'Untitled' : _titleController.text.trim();

    await driveService.updateNote(
      widget.noteFile.id!,
      _contentController.text,
      newTitle: newTitle,
    );

    await ref.read(driveFilesProvider.notifier).refreshFiles();

    setState(() => _isSaving = false);
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note updated')),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timestamp = '${_formatWeekday(now)}, ${_formatDate(now)} at ${_formatTime(now)}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // or Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface, // makes it adapt to light/dark theme
        elevation: 0,
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isSaving ? null : _saveNote,
            color: Theme.of(context).colorScheme.primary, // or any theme color
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
}
