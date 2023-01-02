import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/repositories/song_repo.dart';
import 'package:musicapp1/utilities/app_enums.dart';
import 'package:musicapp1/utilities/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/song_model.dart';

abstract class ISongService {
  Future<void> saveSong(Song song);
  Future<void> markUnmarkAsFavourite(String uuid, bool matched);
  Future<List<Song>> getMostRecentSongs({int count = 100000});
  Future<List<Song>> getFavouriteSongs();
}

@Injectable(as: ISongService)
class SongService implements ISongService {
  final songRepo = getIT<ISongRepository>();
  final prefs = getIT<SharedPreferences>();
  SongService() {
    var loaded = prefs.getBool(LoadStatus.songsLoaded) ?? false;
    if (loaded == false) {
      loadInitialSongs();
      prefs.setBool(LoadStatus.songsLoaded, true);
    }
  }

  @override
  Future<void> saveSong(Song song) async {
    song.uuid = const Uuid().v4();
    song.addDate = DateTime.now();
    await songRepo.saveSong(song);
  }

  @override
  Future<void> markUnmarkAsFavourite(String uuid, bool matched) =>
      songRepo.markAsFavourite(uuid, matched);

  @override
  Future<List<Song>> getMostRecentSongs({int count = 1000000}) async {
    var songs = await songRepo.getSongs();
    songs = songs.where((sg) => File(sg.url).isValid()).take(count).toList();
    songs.sort((s1, s2) => s1.addDate.compareTo(s2.addDate));
    print('Returned ${songs.length}, take $count');
    return songs;
  }

  void loadInitialSongs() {
    var song1 = Song(
        coverUrl: "assets/images/glass.png",
        title: "Glass",
        url: "assets/music/glass.mp3",
        description: "Glass");

    var song2 = Song(
        coverUrl: "assets/images/illusions.png",
        title: "Illussions",
        url: "assets/music/illussions.mp3",
        description: "Illussions");
    var song3 = Song(
        coverUrl: "assets/images/pray.png",
        title: "Pray",
        url: "assets/music/pray.mp3",
        description: "Praying");

    saveSong(song1);
    saveSong(song2);
    saveSong(song3);
  }

  @override
  Future<List<Song>> getFavouriteSongs() async {
    var list = await songRepo.getSongs();
    return list.where((sg) => sg.isFavourite).toList();
  }
}
