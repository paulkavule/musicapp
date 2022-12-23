import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp1/models/seekbar_model.dart';
import 'package:musicapp1/providers/app_provider.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../models/song_model.dart';

class MultiMusicPlayer extends ConsumerStatefulWidget {
  const MultiMusicPlayer({Key? key, required this.playList}) : super(key: key);
  final List<Song> playList;
  // final Function(int)? setActiveSong;
  // final int? activeSong;
  @override
  MultiMusicPlayerState createState() => MultiMusicPlayerState();
}

class MultiMusicPlayerState extends ConsumerState<MultiMusicPlayer> {
  AudioPlayer player = AudioPlayer();
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    List<AudioSource>? audioSource = [];
    for (var song in widget.playList) {
      audioSource.add(AudioSource.uri(Uri.parse('asset:///${song.url}')));
    }
    //print('restarted state');
    // print('sent index ${widget.activeSong}');
    // currentIndex = widget.activeSong ?? 0;
    player.setAudioSource(ConcatenatingAudioSource(children: audioSource),
        initialIndex: currentIndex);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Stream<SeekBarDto> get seekBarStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarDto>(
          player.positionStream, player.durationStream, (
        Duration pst,
        Duration? dur,
      ) {
        return SeekBarDto(pst, dur ?? Duration.zero);
      });

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(playerProvider, (prev, next) async {
      await player.seek(const Duration(seconds: 10), index: next);
      if (player.playing == false) {
        player.play();
      }
      // print('player => next index is   $next');
    });

    return Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/pray.png',
              height: 35,
              width: 35,
            )),
        Expanded(
            child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Text(widget.playList[currentIndex].titlte)),
                StreamBuilder<SequenceState?>(
                    stream: player.sequenceStateStream,
                    builder: (context, snapshot) {
                      return IconButton(
                          onPressed: () {
                            if (player.hasPrevious) {
                              player.seekToPrevious();
                              ref.read(playerProvider.notifier).state--;
                            }
                          },
                          padding: const EdgeInsets.all(0.0),
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.skip_previous,
                              color: Colors.white));
                    }),
                const SizedBox(
                  width: 10,
                ),
                StreamBuilder(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final playerState = snapshot.data;
                      final processState = (playerState!).processingState;

                      if (processState == ProcessingState.loading ||
                          processState == ProcessingState.buffering) {
                        return Container(
                          width: 75,
                          height: 75,
                          margin: const EdgeInsets.all(10.0),
                          child: const CircularProgressIndicator(),
                        );
                      } else if (player.playing == false) {
                        return IconButton(
                            onPressed: () => player.play(),
                            icon: const Icon(
                              Icons.play_circle,
                              color: Colors.orange,
                            ),
                            padding: const EdgeInsets.all(0.0),
                            constraints: const BoxConstraints());
                      } else if (processState != ProcessingState.completed) {
                        return IconButton(
                            onPressed: () => player.pause(),
                            icon: const Icon(Icons.pause_circle,
                                color: Colors.orange),
                            padding: const EdgeInsets.all(0.0),
                            constraints: const BoxConstraints());
                      }
                      return IconButton(
                          onPressed: () => player.seek(Duration.zero,
                              index: player.effectiveIndices!.first),
                          icon: const Icon(Icons.replay_circle_filled_outlined,
                              color: Colors.orange),
                          padding: const EdgeInsets.all(0.0),
                          constraints: const BoxConstraints());
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                StreamBuilder<SequenceState?>(
                    stream: player.sequenceStateStream,
                    builder: (context, snapshot) {
                      return IconButton(
                          onPressed: () {
                            if (player.hasNext) {
                              player.seekToNext();
                              ref.read(playerProvider.notifier).state++;
                            }
                          },
                          icon:
                              const Icon(Icons.skip_next, color: Colors.white),
                          padding: const EdgeInsets.all(0.0),
                          constraints: const BoxConstraints());
                    }),
              ],
            ),
            StreamBuilder(
              stream: seekBarStream,
              builder: (context, snapshot) {
                final postionData = snapshot.data;
                // print('Duration: ${postionData?.duration} | position: ${postionData?.position}');
                return SeekBar(
                  position: postionData?.position ?? Duration.zero,
                  duration: postionData?.duration ?? Duration.zero,
                  showTime: false,
                  onChangEnd: player.seek,
                );
              },
            ),
          ],
        ))
      ],
    );
  }
}
