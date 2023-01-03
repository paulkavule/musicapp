import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp1/models/seekbar_model.dart';
import 'package:musicapp1/providers/app_provider.dart';
import 'package:musicapp1/utilities/helpers.dart';
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
  AudioPlayer? player; //= AudioPlayer();

  int currentIndex = 0;
  @override
  void initState() {
    super.initState();

    // player!.play();
    // print('Songs loaded');
  }

  @override
  void dispose() {
    player?.dispose();
    super.dispose();
  }

  Stream<SeekBarDto> get seekBarStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarDto>(
          player!.positionStream, player!.durationStream, (
        Duration pst,
        Duration? dur,
      ) {
        return SeekBarDto(pst, dur ?? Duration.zero);
      });

  @override
  Widget build(BuildContext context) {
    player = ref.watch(auidoPlayer);

    ref.read(auidoPlayer.notifier).addData(widget.playList, 0);

    ref.listen<int>(playerProvider, (prev, next) async {
      await player!.seek(const Duration(seconds: 0), index: next);
      if (player!.playing == false) {
        player!.play();
      }
      // print('player => next index is   $next');
    });
    if (widget.playList.isEmpty) {
      return const SizedBox(
        height: 10,
      );
    }
    return Expanded(
      flex: 1,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: getImage(widget.playList[currentIndex].coverUrl)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.playList[0].title,
                    overflow: TextOverflow.clip,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  StreamBuilder<SequenceState?>(
                      stream: player!.sequenceStateStream,
                      builder: (context, snapshot) {
                        return IconButton(
                            onPressed: () {
                              if (player!.hasPrevious) {
                                player!.seekToPrevious();
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
                    stream: player!.playerStateStream,
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
                        } else if (player!.playing == false) {
                          return IconButton(
                              onPressed: () => player!.play(),
                              icon: const Icon(
                                Icons.play_circle,
                                color: Colors.orange,
                              ),
                              padding: const EdgeInsets.all(0.0),
                              constraints: const BoxConstraints());
                        } else if (processState != ProcessingState.completed) {
                          return IconButton(
                              onPressed: () => player!.pause(),
                              icon: const Icon(Icons.pause_circle,
                                  color: Colors.orange),
                              padding: const EdgeInsets.all(0.0),
                              constraints: const BoxConstraints());
                        }
                        return IconButton(
                            onPressed: () {
                              player!.seek(Duration.zero,
                                  index: player!.effectiveIndices!.first);
                              ref.read(playerProvider.notifier).state = 0;
                            },
                            icon: const Icon(
                                Icons.replay_circle_filled_outlined,
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
                      stream: player!.sequenceStateStream,
                      builder: (context, snapshot) {
                        return IconButton(
                            onPressed: () async {
                              // print('Next button clicked');
                              if (player!.hasNext) {
                                // await player.seek(Duration.zero,
                                //     index: player.nextIndex);
                                player!.seekToNext();
                                ref.read(playerProvider.notifier).state++;
                                // print('Next button selected');
                              }
                            },
                            icon: const Icon(Icons.skip_next,
                                color: Colors.white),
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
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: SeekBar(
                      position: postionData?.position ?? Duration.zero,
                      duration: postionData?.duration ?? Duration.zero,
                      showTime: false,
                      onChangEnd: player!.seek,
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
    // return const SizedBox(
    //   height: 10,
    // );

    // return Row(
    //   children: [
    //     ClipRRect(
    //         borderRadius: BorderRadius.circular(10),
    //         child: getImage(widget.playList[currentIndex].coverUrl)),
    //     Column(
    //       children: [
    //         Row(
    //           children: [
    //             const SizedBox(
    //               width: 10,
    //             ),
    //             Text(widget.playList[currentIndex].title),
    //             StreamBuilder<SequenceState?>(
    //                 stream: player!.sequenceStateStream,
    //                 builder: (context, snapshot) {
    //                   return IconButton(
    //                       onPressed: () {
    //                         if (player!.hasPrevious) {
    //                           player!.seekToPrevious();
    //                           ref.read(playerProvider.notifier).state--;
    //                         }
    //                       },
    //                       padding: const EdgeInsets.all(0.0),
    //                       constraints: const BoxConstraints(),
    //                       icon: const Icon(Icons.skip_previous,
    //                           color: Colors.white));
    //                 }),
    //             const SizedBox(
    //               width: 10,
    //             ),
    //             StreamBuilder(
    //               stream: player!.playerStateStream,
    //               builder: (context, snapshot) {
    //                 if (snapshot.hasData) {
    //                   final playerState = snapshot.data;
    //                   final processState = (playerState!).processingState;

    //                   if (processState == ProcessingState.loading ||
    //                       processState == ProcessingState.buffering) {
    //                     return Container(
    //                       width: 75,
    //                       height: 75,
    //                       margin: const EdgeInsets.all(10.0),
    //                       child: const CircularProgressIndicator(),
    //                     );
    //                   } else if (player!.playing == false) {
    //                     return IconButton(
    //                         onPressed: () => player!.play(),
    //                         icon: const Icon(
    //                           Icons.play_circle,
    //                           color: Colors.orange,
    //                         ),
    //                         padding: const EdgeInsets.all(0.0),
    //                         constraints: const BoxConstraints());
    //                   } else if (processState != ProcessingState.completed) {
    //                     return IconButton(
    //                         onPressed: () => player!.pause(),
    //                         icon: const Icon(Icons.pause_circle,
    //                             color: Colors.orange),
    //                         padding: const EdgeInsets.all(0.0),
    //                         constraints: const BoxConstraints());
    //                   }
    //                   return IconButton(
    //                       onPressed: () {
    //                         player!.seek(Duration.zero,
    //                             index: player!.effectiveIndices!.first);
    //                         ref.read(playerProvider.notifier).state = 0;
    //                       },
    //                       icon: const Icon(Icons.replay_circle_filled_outlined,
    //                           color: Colors.orange),
    //                       padding: const EdgeInsets.all(0.0),
    //                       constraints: const BoxConstraints());
    //                 } else {
    //                   return const CircularProgressIndicator();
    //                 }
    //               },
    //             ),
    //             const SizedBox(
    //               width: 10,
    //             ),
    //             StreamBuilder<SequenceState?>(
    //                 stream: player!.sequenceStateStream,
    //                 builder: (context, snapshot) {
    //                   return IconButton(
    //                       onPressed: () async {
    //                         print('Next button clicked');
    //                         if (player!.hasNext) {
    //                           // await player.seek(Duration.zero,
    //                           //     index: player.nextIndex);
    //                           player!.seekToNext();
    //                           ref.read(playerProvider.notifier).state++;
    //                           print('Next button selected');
    //                         }
    //                       },
    //                       icon:
    //                           const Icon(Icons.skip_next, color: Colors.white),
    //                       padding: const EdgeInsets.all(0.0),
    //                       constraints: const BoxConstraints());
    //                 }),
    //           ],
    //         ),
    //         StreamBuilder(
    //           stream: seekBarStream,
    //           builder: (context, snapshot) {
    //             final postionData = snapshot.data;
    //             // print('Duration: ${postionData?.duration} | position: ${postionData?.position}');
    //             return SeekBar(
    //               position: postionData?.position ?? Duration.zero,
    //               duration: postionData?.duration ?? Duration.zero,
    //               showTime: false,
    //               onChangEnd: player!.seek,
    //             );
    //           },
    //         ),
    //       ],
    //     )
    //   ],
    // );
  }
}
