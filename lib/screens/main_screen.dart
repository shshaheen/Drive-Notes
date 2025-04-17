import 'package:drive_notes/screens/create_note_screen.dart';
import 'package:drive_notes/screens/edit_note_screen.dart';
import 'package:drive_notes/services/drive_service.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class MainScreen extends StatelessWidget {
  final DriveService driveService;

  const MainScreen({required this.driveService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Drive Notes")),
      body: FutureBuilder(
        future: driveService.listNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final files = snapshot.data as List<drive.File>;

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return ListTile(
                title: Text(file.name ?? "Unnamed"),
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
        child: Icon(Icons.add),
      ),
    );
  }
}
