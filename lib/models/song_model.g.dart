// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongAdapter extends TypeAdapter<Song> {
  @override
  final int typeId = 1;

  @override
  Song read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Song(
      title: fields[0] as String,
      description: fields[1] as String,
      url: fields[2] as String,
      coverUrl: fields[3] as String,
      isFavourite: fields[4] as bool,
      genera: fields[6] as String,
      uuid: fields[9] as String,
      id: fields[7] as int,
    )
      ..addDate = fields[8] as DateTime
      ..playList = (fields[5] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, Song obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.coverUrl)
      ..writeByte(8)
      ..write(obj.addDate)
      ..writeByte(4)
      ..write(obj.isFavourite)
      ..writeByte(5)
      ..write(obj.playList)
      ..writeByte(6)
      ..write(obj.genera)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.uuid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
