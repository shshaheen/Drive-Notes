import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import '../services/drive_service.dart';
import 'auth_state_provider.dart';

class DriveFilesNotifier extends AsyncNotifier<List<drive.File>> {
  late final DriveService _driveService;

  @override
  FutureOr<List<drive.File>> build() async {
    final auth = ref.watch(authStateProvider).value;
    if (auth == null) return [];

    final authService = ref.read(authStateProvider.notifier).authService;
    final driveApi = drive.DriveApi(authService.getAuthenticatedClient());
    _driveService = DriveService(driveApi);

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
    AsyncNotifierProvider<DriveFilesNotifier, List<drive.File>>(
        () => DriveFilesNotifier());
