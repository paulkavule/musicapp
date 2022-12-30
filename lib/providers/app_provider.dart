import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp1/models/playlist_model.dart';

final playerProvider = StateProvider((ref) => 0);

// final appPlayList = StateProvider((plist) => List<PlayList>);

final StateNotifierProvider<PlaylistNotifier, List<PlayList>> appPlayList =
    StateNotifierProvider((ref) => PlaylistNotifier());

class PlaylistNotifier extends StateNotifier<List<PlayList>> {
  PlaylistNotifier() : super([]);

  void addData(PlayList plist) {
    state = [...state, plist];
  }

  void removeData(String uuid) {
    state.removeWhere((pl) => pl.uuid == uuid);
  }

  void refereshData(List<PlayList> data) {
    state = [...data];
  }
}
