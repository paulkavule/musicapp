import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:musicapp1/models/playlist_model.dart';

abstract class IPlaylistRepository {
  Future<void> savePlaylist(PlayList playList);
  Future<void> deletePlaylist(String uuid);
  Future<List<String>> getPlayLists();
  Future<List<PlayList>> getDetailedPlayLists();
}

@Injectable(as: IPlaylistRepository)
class PlaylistRepository implements IPlaylistRepository {
  Box<PlayList> get playlistTb => Hive.box('cpm_playlistdb');
  PlaylistRepository();

  @override
  Future<void> savePlaylist(PlayList playList) async {
    if (playlistTb.values.any((pl) => pl.title == playList.title)) {
      return;
    }

    await playlistTb.put(playList.uuid, playList);
    // for (var data in playlistTb.values.toList()) {
    //   print('Object name: ${data.title}');
    // }
  }

  @override
  Future<void> deletePlaylist(String uuid) async =>
      await playlistTb.delete(uuid);

  @override
  Future<List<String>> getPlayLists() async =>
      playlistTb.values.map<String>((song) => song.title).toList();

  @override
  Future<List<PlayList>> getDetailedPlayLists() async =>
      playlistTb.values.toList();
}
