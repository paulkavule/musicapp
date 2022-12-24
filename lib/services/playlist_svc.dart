import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/repositories/playlist_repo.dart';
import 'package:uuid/uuid.dart';

import '../models/playlist_model.dart';
import '../repositories/song_repo.dart';

abstract class IPlaylistService {
  savePlayList(String name, String coverUrl);

  Future<List<PlayList>> getPlayList();

  void deleteItem(String uuid) {}
}

@Injectable(as: IPlaylistService)
class PlaylistService implements IPlaylistService {
  var plistRepo = getIT<IPlaylistRepository>();
  var songRepo = getIT<ISongRepository>();
  @override
  Future<void> savePlayList(String name, String coverUrl) async {
    var playList = PlayList(imageUrl: coverUrl, title: name);
    playList.uuid = const Uuid().v4();
    await plistRepo.savePlaylist(playList);
  }

  @override
  Future<List<PlayList>> getPlayList() async {
    var playList = await plistRepo.getDetailedPlayLists();
    var songList = await songRepo.getSongs();
    for (var item in playList) {
      final playSongs = songList
          .where((sg) =>
              sg.playList.contains(item.title) && File(sg.url).existsSync())
          .toList();
      item.songs = playSongs;
    }
    return playList;
  }

  @override
  void deleteItem(String uuid) async {
    await plistRepo.deletePlaylist(uuid);
  }
}
