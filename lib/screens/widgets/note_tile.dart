import 'package:drive_notes/services/drive_service.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class NoteTile extends StatelessWidget {
  final drive.File file;
  final VoidCallback onTap;
  final DriveService driveService;
  final VoidCallback onDelete; // To refresh the list after deletion

  const NoteTile({
    super.key,
    required this.file,
    required this.onTap,
    required this.driveService,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.description, color: Colors.blueAccent),
        title: Text(
          (file.name != null && file.name!.endsWith('.txt'))
              ? file.name!.replaceAll(RegExp(r'\.txt$'), '')
              : (file.name ?? 'Untitled'),
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
            await driveService.deleteNote(file.id!);
            onDelete(); // Call back to refresh the notes list
          }
        },
      ),
    );
  }
}
