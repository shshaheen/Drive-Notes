import 'package:drive_notes/models/note_file.dart';
import 'package:drive_notes/screens/widgets/note_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NoteTile calls onTap when tapped', (WidgetTester tester) async {
    bool tapped = false;

    final testNote = NoteFile(
      id: '1',
      name: 'Test Note',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteTile(
            file: testNote,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    // Tap the tile
    await tester.tap(find.byType(ListTile));
    await tester.pump(); // finish animations

    // Assert that onTap was called
    expect(tapped, isTrue);
  });
}
