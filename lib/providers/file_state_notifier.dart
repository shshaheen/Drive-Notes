import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/note_file.dart';
import '../services/drive_service.dart';
import 'auth_state_provider.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class DriveFilesNotifier extends AsyncNotifier<List<NoteFile>> {
  late final DriveService _driveService;
  late final Box<NoteFile> _notesBox;

  @override
  FutureOr<List<NoteFile>> build() async {
    _notesBox = Hive.box<NoteFile>('notesBox');

    final auth = ref.watch(authStateProvider).value;
    if (auth == null) {
      // Load cached notes when user is not signed in
      return _notesBox.values.toList();
    }

    final authService = ref.read(authStateProvider.notifier).authService;
    final client = authService.getAuthenticatedClient();
    _driveService = DriveService(drive.DriveApi(client));

    // Try fetching from Drive, fall back to cache if it fails
    try {
      final files = await _driveService.listNoteFiles();
      // Save to Hive cache
      await _saveToCache(files);
      return files;
    } catch (_) {
      // Load from Hive on failure
      return _notesBox.values.toList();
    }
  }

  Future<void> refreshFiles() async {
    state = const AsyncLoading();
    try {
      final files = await _driveService.listNoteFiles();
      await _saveToCache(files);
      state = AsyncData(files);
    } catch (_) {
      // fallback to cached data
      state = AsyncData(_notesBox.values.toList());
    }
  }

  Future<void> deleteFile(String fileId) async {
    await _driveService.deleteNote(fileId);
    await refreshFiles();
  }

  DriveService get driveService => _driveService;

  Future<void> _saveToCache(List<NoteFile> files) async {
    await _notesBox.clear();
    for (final file in files) {
      await _notesBox.put(file.id, file);
    }
  }
}



final driveFilesProvider =
    AsyncNotifierProvider<DriveFilesNotifier, List<NoteFile>>(
        () => DriveFilesNotifier());
