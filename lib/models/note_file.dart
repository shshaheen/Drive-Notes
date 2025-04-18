import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note_file.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class NoteFile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  NoteFile({
    required this.id,
    required this.name,
  });

  factory NoteFile.fromJson(Map<String, dynamic> json) =>
      _$NoteFileFromJson(json);

  Map<String, dynamic> toJson() => _$NoteFileToJson(this);
}
