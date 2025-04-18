import 'package:json_annotation/json_annotation.dart';

part 'note_file.g.dart';

@JsonSerializable()
class NoteFile {
  final String id;
  final String name;

  NoteFile({
    required this.id,
    required this.name,
  });

  factory NoteFile.fromJson(Map<String, dynamic> json) =>
      _$NoteFileFromJson(json);

  Map<String, dynamic> toJson() => _$NoteFileToJson(this);
}
