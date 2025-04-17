import 'dart:convert';
import 'package:googleapis/drive/v3.dart' as drive;

class DriveService {
  final drive.DriveApi driveApi;

  DriveService(this.driveApi);

  Future<String> _getOrCreateDriveNotesFolder() async {
    final query =
        "mimeType = 'application/vnd.google-apps.folder' and name = 'DriveNotes' and trashed = false";
    final result = await driveApi.files.list(q: query);
    if (result.files?.isNotEmpty ?? false) {
      return result.files!.first.id!;
    }

    final folder = drive.File()
      ..name = 'DriveNotes'
      ..mimeType = 'application/vnd.google-apps.folder';

    final folderResult = await driveApi.files.create(folder);
    return folderResult.id!;
  }

  Future<void> uploadNote(String content, String title) async {
    final folderId = await _getOrCreateDriveNotesFolder();

    final file = drive.File()
      ..name = "$title.txt"
      ..parents = [folderId];

    final media = drive.Media(
      Stream.value(content.codeUnits),
      content.length,
    );

    await driveApi.files.create(file, uploadMedia: media);
  }

  Future<List<drive.File>> listNoteFiles() async {
    final folderId = await _getOrCreateDriveNotesFolder();
    final query =
        "'$folderId' in parents and mimeType = 'text/plain' and trashed = false";
    final result = await driveApi.files.list(
      q: query,
      spaces: 'drive',
      $fields: 'files(id, name, modifiedTime)',
    );
    return result.files ?? [];
  }

  Future<String> downloadNoteContent(String fileId) async {
    final response = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    );

    if (response is! drive.Media) {
      throw Exception("Download failed: Not a Media object");
    }

    final content = await response.stream.transform(utf8.decoder).join();
    return content;
  }

  Future<void> deleteNote(String fileId) async {
    await driveApi.files.delete(fileId);
  }

  Future<void> updateNote(String fileId, String newContent,
      {String? newTitle}) async {
    final media = drive.Media(
      Stream.value(newContent.codeUnits),
      newContent.length,
    );

    final file = drive.File();
    if (newTitle != null && newTitle.trim().isNotEmpty) {
      file.name = '$newTitle.txt';
    }

    await driveApi.files.update(file, fileId, uploadMedia: media);
  }
}
