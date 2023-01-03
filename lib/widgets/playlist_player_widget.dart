import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/providers/app_provider.dart';
import 'package:musicapp1/services/music_player.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../models/seekbar_model.dart';
import '../models/song_model.dart';
import '../utilities/helpers.dart';

class PlaylistPlayer extends ConsumerStatefulWidget {
  const PlaylistPlayer(
      {Key? key, required this.playList, required this.startPlaying})
      : super(key: key);
  final List<Song> playList;
  final bool startPlaying;
  @override
  PlaylistPlayerState createState() => PlaylistPlayerState();
}

class PlaylistPlayerState extends ConsumerState<PlaylistPlayer> {
  IMusicPlayerService get player => getIT<IMusicPlayerService>();
  int activeSong = 0;
  @override
  void initState() {
    super.initState();
    player.loadSongs(widget.playList, activeSong);
    // if (player != null) {
    //   if (player!.playing) {
    //     player!.stop();
    //   }
    // }
    // print('Songs loaded');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<SeekBarDto> get seekBarStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarDto>(
          player.audioPlayer.positionStream, player.audioPlayer.durationStream,
          (
        Duration pst,
        Duration? dur,
      ) {
        return SeekBarDto(pst, dur ?? Duration.zero);
      });

  @override
  Widget build(BuildContext context) {
    activeSong = ref.watch(playerProvider);
    // player = ref.watch(auidoPlayer);
    // print('There is another ${player!.hasNext}');
    // if (player!.hasNext == false) {
    //   ref.read(auidoPlayer.notifier).addData(widget.playList, activeSong);
    // }

    ref.listen<int>(playerProvider, (prev, next) async {
      await player.audioPlayer.seek(const Duration(seconds: 0), index: next);
      if (player.audioPlayer.playing == false) {
        player.play();
      }
      // print('player => next index is   $next');
    });
    if (widget.startPlaying) {
      player.play();
    }
    return Container(
      // color: Colors.brown.shade400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.brown.shade600.withOpacity(0.5),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 50,
            // color: Colors.brown,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: getImage(widget.playList[activeSong].coverUrl)),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.playList[activeSong].title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  widget.playList[activeSong].description,
                  style: Theme.of(context).textTheme.bodySmall,
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
                      onChangEnd: player.audioPlayer.seek,
                    );
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StreamBuilder<SequenceState?>(
                  stream: player.audioPlayer.sequenceStateStream,
                  builder: (context, snapshot) {
                    return IconButton(
                        onPressed: () {
                          if (player.audioPlayer.hasPrevious) {
                            player.skipPrevious();
                            ref.read(playerProvider.notifier).state--;
                          }
                        },
                        padding: const EdgeInsets.all(0.0),
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.skip_previous,
                            size: 30, color: Colors.white));
                  }),
              const SizedBox(
                width: 5,
              ),
              StreamBuilder(
                stream: player.audioPlayer.playerStateStream,
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
                    } else if (player.audioPlayer.playing == false) {
                      return IconButton(
                          onPressed: () => player.play(),
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.play_circle,
                            color: Colors.orange,
                            size: 30,
                          ),
                          padding: const EdgeInsets.all(0.0));
                    } else if (processState != ProcessingState.completed) {
                      return IconButton(
                          onPressed: () => player.pause(),
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.pause_circle,
                            color: Colors.orange,
                            size: 30,
                          ),
                          padding: const EdgeInsets.all(0.0));
                    }
                    return IconButton(
                        onPressed: () {
                          player.audioPlayer.seek(Duration.zero,
                              index:
                                  player.audioPlayer.effectiveIndices!.first);
                          ref.read(playerProvider.notifier).state = 0;
                        },
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.replay_circle_filled_outlined,
                          color: Colors.orange,
                          size: 30,
                        ),
                        padding: const EdgeInsets.all(0.0));
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(
                width: 5,
              ),
              StreamBuilder<SequenceState?>(
                  stream: player.audioPlayer.sequenceStateStream,
                  builder: (context, snapshot) {
                    return IconButton(
                        onPressed: () async {
                          if (player.audioPlayer.hasNext) {
                            // await player.seek(Duration.zero,
                            //     index: player.nextIndex);
                            player.audioPlayer.seekToNext();
                            ref.read(playerProvider.notifier).state++;
                          }
                        },
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 30,
                        ),
                        padding: const EdgeInsets.all(0.0));
                  }),
            ],
          )
        ],
      ),
    );
  }
}
