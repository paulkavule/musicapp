import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../models/song_model.dart';
import '../utilities/helpers.dart';

abstract class IMusicPlayerService {
  void loadSongs(List<Song> songs, int startIndex);
  void play();
  void stop();
  void pause();
  void skipNext();
  void skipPrevious();
  AudioPlayer get audioPlayer;
  // FutureOr disposePlayer(MusicPlayerService player);
}

@Singleton(as: IMusicPlayerService)
class MusicPlayerService implements IMusicPlayerService {
  AudioPlayer player = AudioPlayer();
  MusicPlayerService();

  get disposePlayer => null;

  @override
  void loadSongs(List<Song> songs, int startIndex) {
    try {
      List<AudioSource>? audioSource = [];
      int count = 1;
      for (var song in songs) {
        var songUri = getUriResource(song.url);
        var coverUrl = getUriResource(song.coverUrl);
        audioSource.add(AudioSource.uri(songUri,
            tag: MediaItem(id: '$count', title: song.title, artUri: coverUrl)));

        count++;
      }

      player.setAudioSource(ConcatenatingAudioSource(children: audioSource),
          initialIndex: startIndex);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  AudioPlayer get audioPlayer => player;

  @override
  void pause() => player.pause();

  @override
  void play() => player.play();

  @override
  void skipNext() => player.seekToNext();

  @override
  void skipPrevious() => player.seekToPrevious();

  @override
  void stop() => player.stop();
}

FutureOr disposePlayer(MusicPlayerService player) {
  player.audioPlayer.dispose();
}
