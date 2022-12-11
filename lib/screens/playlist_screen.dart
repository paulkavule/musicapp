import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp1/models/playlist_model.dart';
import 'package:musicapp1/providers/app_provider.dart';
import 'package:musicapp1/widgets/widgets.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlayList playList = Get.arguments ?? PlayList.playList[0];

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Playlist'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlaylistWidget(playList: playList),
                const SizedBox(
                  height: 20,
                ),
                const PlayOrShuffleSwitch(),
                SongPlayListWidget(playList: playList),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SongPlayListWidget extends ConsumerStatefulWidget {
  const SongPlayListWidget({
    Key? key,
    required this.playList,
  }) : super(key: key);

  final PlayList playList;

  @override
  _SongPlayListWidgetState createState() => _SongPlayListWidgetState();
}

class _SongPlayListWidgetState extends ConsumerState<SongPlayListWidget> {
  // PlayingSong(index){
  //   setState(() {
  //     activeSong = index;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    final int activeSong = ref.watch(playerProvider);

    ref.listen<int>(playerProvider, (prev, next) {
      print('playscreen => next index is   $next');
    });

    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.playList.songs.length,
            itemBuilder: (context, index) {
              var player = AudioPlayer().setAudioSource(
                  AudioSource.uri(Uri.parse(widget.playList.songs[index].url)));

              // AudioPlayer().setu(widget.playList.songs[index].url);
              return ListTile(
                leading: Text(
                  '${index + 1}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                title: Text(
                  widget.playList.songs[index].titlte,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${widget.playList.songs[index].description} ø',
                ),
                trailing: const Icon(Icons.more_vert, color: Colors.white),
                selected: index == activeSong,
                selectedColor: Colors.orange,
                onTap: () {
                  ref.read(playerProvider.notifier).state = index;
                  // PlayingSong(index);
                },
              );
            }),
        MultiMusicPlayer(playList: widget.playList)
      ],
    );
  }
}

class PlayOrShuffleSwitch extends StatefulWidget {
  const PlayOrShuffleSwitch({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayOrShuffleSwitch> createState() => PlayOrShuffleSwitchState();
}

class PlayOrShuffleSwitchState extends State<PlayOrShuffleSwitch> {
  bool isPlay = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          isPlay = !isPlay;
        });
      },
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Stack(children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: isPlay ? 0 : width * 0.45,
            child: Container(
              height: 50,
              width: width * 0.45,
              decoration: BoxDecoration(
                  color: Colors.deepPurple.shade400,
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text('Play',
                          style: TextStyle(
                              color: isPlay ? Colors.white : Colors.deepPurple,
                              fontSize: 17)),
                    ),
                    Icon(
                      Icons.play_circle,
                      color: isPlay ? Colors.white : Colors.deepPurple,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text('Shuffle',
                          style: TextStyle(
                              color: isPlay ? Colors.deepPurple : Colors.white,
                              fontSize: 17)),
                    ),
                    Icon(
                      Icons.shuffle,
                      color: isPlay ? Colors.deepPurple : Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({
    Key? key,
    required this.playList,
  }) : super(key: key);

  final PlayList playList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.network(
            playList.imageUrl,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          playList.title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
