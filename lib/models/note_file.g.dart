// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteFileAdapter extends TypeAdapter<NoteFile> {
  @override
  final int typeId = 0;

  @override
  NoteFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteFile(
      id: fields[0] as String,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NoteFile obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteFile _$NoteFileFromJson(Map<String, dynamic> json) => NoteFile(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$NoteFileToJson(NoteFile instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
