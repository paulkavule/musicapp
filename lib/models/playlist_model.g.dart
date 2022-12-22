// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayListAdapter extends TypeAdapter<PlayList> {
  @override
  final int typeId = 2;

  @override
  PlayList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayList(
      title: fields[0] as String,
      imageUrl: fields[2] as String,
      songs: (fields[1] as List).cast<Song>(),
    )..Uuid = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, PlayList obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.songs)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.Uuid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
