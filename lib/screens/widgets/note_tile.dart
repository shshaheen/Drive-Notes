import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drive_notes/models/note_file.dart'; // Import your NoteFile model
import 'package:drive_notes/providers/file_state_notifier.dart';

class NoteTile extends ConsumerWidget {
  final NoteFile file;
  final VoidCallback onTap;

  const NoteTile({
    super.key,
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.description, color: Colors.blueAccent),
        title: Text(
          file.name.endsWith('.txt')
              ? file.name.replaceAll(RegExp(r'\.txt$'), '')
              : file.name,
        ),
        onTap: onTap,
        onLongPress: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Note'),
              content: const Text('Are you sure you want to delete this note?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );

          if (confirm == true) {
            await ref.read(driveFilesProvider.notifier).deleteFile(file.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note deleted')),
            );
          }
        },
      ),
    );
  }
}
