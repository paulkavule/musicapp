import 'package:hive/hive.dart';
import 'package:musicapp1/models/playlist_model.dart';

abstract class IPlaylistRepository {}

class PlaylistRepository implements IPlaylistRepository {
  Box<PlayList>? playlistTb;
  PlaylistRepository(String name) {
    playlistTb = Hive.box(name);
  }
  Future<void> savePlaylist(PlayList playList) async {
    if (playlistTb!.values.any((pl) => pl.title == playList.title)) {
      return null;
    }

    await playlistTb!.add(playList);
  }

  Future<void> deletePlaylist(String id) async {
    var plist = playlistTb!.values.firstWhere((pl) => pl.Uuid == id);
    await playlistTb!.delete(plist);
  }

  Future<List<String>> getPlayLists() async {
    return playlistTb!.values.map<String>((song) => song.title).toList();
    // playlistTb!.values.where((song) => song.playList.isNotEmpty).toList();

    // var list = playlistTb!.values.map<String>((e) => e.playList);
    // Set<String> playList = {};
    // for (var pl in list) {
    //   playList.addAll(pl.split(','));
    // }
    // return playList.toList();
  }
}
