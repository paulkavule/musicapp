import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../models/song_model.dart';

abstract class ISongRepository {
  Future<void> saveSong(Song song);
  Future<void> deleteSong(String uuid);
  Future<void> updateSong(Song song);
  Future<void> markAsFavourite(String uuid, bool matched);
  Future<List<Song>> getSongs();
}

@Injectable(as: ISongRepository)
class SongRepository implements ISongRepository {
  Box<Song> songTb = Hive.box('songsdb');
  SongRepository();

  @override
  Future<void> saveSong(Song song) async {
    // var rowid = await songTb.add(song);
    await songTb.put(song.uuid, song);
    print('Inserted ${song.uuid}  Date: ${song.addDate}');
  }

  @override
  Future<void> deleteSong(String uuid) async {
    var song = songTb.values.firstWhere((sg) => sg.uuid == uuid);
    await songTb.delete(song);
  }

  @override
  Future<List<Song>> getSongs() async => songTb.values.toList();

  @override
  Future<void> updateSong(Song song) async => songTb.put(song.id, song);

  @override
  Future<void> markAsFavourite(String uuid, bool matched) async {
    var song = songTb.values.firstWhere((sg) => sg.uuid == uuid);
    song.isFavourite = matched;

    print('markAsFavourite:  id: $uuid uuid: ${song.uuid} ');
    songTb.put(uuid, song);
  }
}
