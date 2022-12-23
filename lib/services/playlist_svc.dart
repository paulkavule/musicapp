import 'package:injectable/injectable.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/repositories/playlist_repo.dart';
import 'package:uuid/uuid.dart';

import '../models/playlist_model.dart';

abstract class IPlaylistService {
  savePlayList(String name, String coverUrl);

  Future<List<PlayList>> getPlayList();

  void deleteItem(String uuid) {}
}

@Injectable(as: IPlaylistService)
class PlaylistService implements IPlaylistService {
  var plistRepo = getIT<IPlaylistRepository>();
  @override
  Future<void> savePlayList(String name, String coverUrl) async {
    var playList = PlayList(imageUrl: coverUrl, title: name);
    playList.uuid = const Uuid().v4();
    await plistRepo.savePlaylist(playList);
  }

  @override
  Future<List<PlayList>> getPlayList() async {
    var list = await plistRepo.getDetailedPlayLists();
    return list;
  }

  @override
  void deleteItem(String uuid) async {
    await plistRepo.deletePlaylist(uuid);
  }
}
