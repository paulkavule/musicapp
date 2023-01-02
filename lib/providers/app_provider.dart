import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicapp1/models/playlist_model.dart';

import '../models/song_model.dart';
import '../utilities/helpers.dart';

final playerProvider = StateProvider((ref) => 0);

// final appPlayList = StateProvider((plist) => List<PlayList>);

final StateNotifierProvider<PlaylistNotifier, List<PlayList>> appPlayList =
    StateNotifierProvider((ref) => PlaylistNotifier());

final StateNotifierProvider<PlayerManager, AudioPlayer> auidoPlayer =
    StateNotifierProvider((ref) => PlayerManager());

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

class PlayerManager extends StateNotifier<AudioPlayer> {
  PlayerManager() : super(AudioPlayer());

  void addData(List<Song> playList, int currentIndex) {
    List<AudioSource>? audioSource = [];
    int count = 1;
    for (var song in playList) {
      var songUri = getUriResource(song.url);
      audioSource.add(AudioSource.uri(songUri,
          tag: MediaItem(id: '$count', title: song.title)));

      count++;
    }

    state.setAudioSource(ConcatenatingAudioSource(children: audioSource),
        initialIndex: currentIndex);
  }
}
