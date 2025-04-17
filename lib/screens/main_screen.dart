import 'package:drive_notes/screens/create_note_screen.dart';
import 'package:drive_notes/screens/edit_note_screen.dart';
import 'package:drive_notes/screens/widgets/note_tile.dart';
import 'package:drive_notes/services/drive_service.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class MainScreen extends StatelessWidget {
  final DriveService driveService;

  const MainScreen({super.key, required this.driveService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Drive Notes"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<drive.File>>(
        future: driveService.listNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text("No notes found in DriveNotes folder."));
          }

          final files = snapshot.data!;

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return NoteTile(
                file: file,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditNoteScreen(
                        noteFile: file,
                        driveService: driveService,
                      ),
                    ),
                  );
                },
                driveService: driveService,
                onDelete: () {
                  // This rebuilds the screen to refresh the list
                  (context as Element).reassemble();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateNoteScreen(driveService: driveService),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
