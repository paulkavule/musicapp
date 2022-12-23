import 'package:injectable/injectable.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/repositories/song_repo.dart';
import 'package:musicapp1/utilities/app_enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/song_model.dart';

abstract class ISongService {
  Future<void> saveSong(Song song);
  Future<void> markUnmarkAsFavourite(String uuid, bool matched);
  Future<List<Song>> getMostRecentSongs();
}

@Injectable(as: ISongService)
class SongService implements ISongService {
  final songRepo = getIT<ISongRepository>();
  final prefs = getIT<SharedPreferences>();
  SongService() {
    var loaded = prefs.getBool(LoadStatus.songsLoaded) ?? false;
    print('Songs Loaded: $loaded');
    if (loaded == false) {
      loadInitialSongs();
      prefs.setBool(LoadStatus.songsLoaded, true);
    }
  }

  @override
  Future<void> saveSong(Song song) async {
    song.id = const Uuid().v4();
    song.addDate = DateTime.now();
    await songRepo.saveSong(song);
  }

  @override
  Future<void> markUnmarkAsFavourite(String uuid, bool matched) =>
      songRepo.markAsFavourite(uuid, matched);

  @override
  Future<List<Song>> getMostRecentSongs() async {
    var songs = await songRepo.getSongs();
    songs.sort((s1, s2) => s1.addDate.compareTo(s2.addDate));
    return songs;
    // return songs.sort((sg1, sg2) => sg1.addDate > sg2.addDate )
    //     //.where((song) => song.da > SystemConfigs.trendingPlayCount)
    //     .toList();
  }

  void loadInitialSongs() {
    var song1 = Song(
        coverUrl: "assets/images/glass.png",
        titlte: "Glass",
        url: "assets/music/glass.mp3",
        description: "Glass");

    var song2 = Song(
        coverUrl: "assets/images/illusions.png",
        titlte: "Illussions",
        url: "assets/music/illussions.mp3",
        description: "Illussions");
    var song3 = Song(
        coverUrl: "assets/images/pray.png",
        titlte: "Pray",
        url: "assets/music/pray.mp3",
        description: "Praying");

    saveSong(song1);
    saveSong(song2);
    saveSong(song3);
  }
}
