import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/models/song_model.dart';
import 'package:musicapp1/services/song_svc.dart';
import 'package:musicapp1/utilities/helpers.dart';
import 'package:musicapp1/widgets/playbutton_widget.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../models/seekbar_model.dart';

class SongScreen extends StatefulWidget {
  final songSvc = getIT<ISongService>();
  SongScreen({Key? key}) : super(key: key);

  @override
  State<SongScreen> createState() => SongScreenState();
}

class SongScreenState extends State<SongScreen> {
  AudioPlayer player = AudioPlayer();
  Song song = Get.arguments ?? Song.songs[0];

  @override
  void initState() {
    super.initState();
    // print('Song id: ${song.id}');
    var uri = getUriResource(song.url);

    player.setAudioSource(ConcatenatingAudioSource(children: [
      AudioSource.uri(uri, tag: MediaItem(id: '1', title: song.titlte))
    ]));
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          getImage(song.coverUrl),
          const BackgroundFilter(),
          MusicPlayer(
              song: song,
              seekBarStream: seekBarStream,
              player: player,
              svc: widget.songSvc)
        ],
      ),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer(
      {Key? key,
      required this.song,
      required this.seekBarStream,
      required this.player,
      required this.svc})
      : super(key: key);
  final Song song;
  final Stream<SeekBarDto> seekBarStream;
  final AudioPlayer player;
  final ISongService svc;

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  // final songSvc = getIT<ISongService>();

  @override
  Widget build(BuildContext context) {
    bool favourite = widget.song.isFavourite;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.song.titlte.truncate(10, placeholder: '..'),
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.song.titlte.length > 10
                ? widget.song
                    .titlte //'${widget.song.titlte}\n${widget.song.description.truncate(30, placeholder: '...')}'
                : widget.song.description.truncate(30, placeholder: '...'),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(
            height: 5,
          ),
          IconButton(
              onPressed: () {
                // context.widget.so
                // context.widget.
                print('Favourite: ${widget.song.isFavourite}');
                setState(() {
                  favourite = !favourite;
                });
                widget.svc.markUnmarkAsFavourite(
                    widget.song.uuid, !widget.song.isFavourite);
              },
              icon: Icon(
                Icons.favorite,
                color: favourite ? Colors.amber.shade700 : Colors.white,
              )),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: widget.seekBarStream,
            builder: (context, snapshot) {
              final postionData = snapshot.data;
              // print('Duration: ${postionData?.duration} | position: ${postionData?.position}');
              return SeekBar(
                position: postionData?.position ?? Duration.zero,
                duration: postionData?.duration ?? Duration.zero,
                onChangEnd: widget.player.seek,
              );
            },
          ),
          PlayButton(player: widget.player),
          // const SizedBox(
          //   height: 30,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     IconButton(
          //         onPressed: () {},
          //         icon: const Icon(
          //           Icons.settings,
          //           color: Colors.white,
          //           size: 25,
          //         )),
          //     IconButton(
          //         onPressed: () {},
          //         icon: const Icon(
          //           Icons.file_download,
          //           color: Colors.white,
          //           size: 25,
          //         ))
          //   ],
          // ),
        ],
      ),
    );
  }
}

class BackgroundFilter extends StatelessWidget {
  const BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstOut,
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0)
            ],
            stops: [
              0.0,
              0.4,
              0.6
            ]).createShader(rect);
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade800
            ])),
      ),
    );
  }
}
