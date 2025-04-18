import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note_file.dart';
import '../services/drive_service.dart';
import 'auth_state_provider.dart';
import 'package:googleapis/drive/v3.dart' as drive;


class DriveFilesNotifier extends AsyncNotifier<List<NoteFile>> {
  late final DriveService _driveService;

  @override
  FutureOr<List<NoteFile>> build() async {
    final auth = ref.watch(authStateProvider).value;
    if (auth == null) return [];

    final authService = ref.read(authStateProvider.notifier).authService;
    final client = authService.getAuthenticatedClient();
    _driveService = DriveService(drive.DriveApi(client));

    return await _driveService.listNoteFiles();
  }


  Future<void> refreshFiles() async {
    state = const AsyncLoading();
    final files = await _driveService.listNoteFiles();
    state = AsyncData(files);
  }

  Future<void> deleteFile(String fileId) async {
    await _driveService.deleteNote(fileId);
    await refreshFiles();
  }

  DriveService get driveService => _driveService;
}

final driveFilesProvider =
    AsyncNotifierProvider<DriveFilesNotifier, List<NoteFile>>(
        () => DriveFilesNotifier());
