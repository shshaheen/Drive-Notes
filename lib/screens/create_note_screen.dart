import 'package:flutter/material.dart';
import '../services/drive_service.dart';
import 'package:flutter/services.dart';

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
  final title = _titleController.text.trim().isEmpty ? 'Untitled' : _titleController.text.trim();
  final content = _contentController.text.trim();
  if (title.isEmpty && content.isEmpty) return;

  // Hide keyboard
  FocusScope.of(context).unfocus();

  setState(() => _isSaving = true);

  await widget.driveService.uploadNote(content, title);

  setState(() => _isSaving = false);

  // Optional haptic feedback
  HapticFeedback.mediumImpact();

  // Show confirmation
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Note saved successfully')),
  );

  // Pop back after a short delay (optional)
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
      body: Padding(
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
                  hintText: 'Start writing...',
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}), // updates char count
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
