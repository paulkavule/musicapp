import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:musicapp1/models/playlist_model.dart';
import 'package:musicapp1/utilities/helpers.dart';
import 'package:musicapp1/widgets/widgets.dart';

import '../providers/app_provider.dart';
import '../widgets/custome_list_tile.dart';

class PlaylistScreen extends ConsumerStatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    final int activeSong = ref.watch(playerProvider);

    PlayList playList = Get.arguments ?? PlayList.playList[0];
    // if (playList.songs == null || playList.songs!.isEmpty) {
    //   // return const NoData(
    //   //     title: 'Ops', message: 'Playlist does not contain any songs');

    // }
    print('Playlist facts ${playList.songs!.length}');
    var songs = playList.songs!;
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.brown.shade800.withOpacity(0.8),
            Colors.brown.shade200.withOpacity(0.8)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Playlist'),
        ),
        // bottomNavigationBar: MultiMusicPlayer(
        //   playList: songs,
        // ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildListDelegate(<Widget>[
                        PlaylistWidget(playList: playList),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            // padding: EdgeInsets.all(5),
                            // scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: songs.length,
                            itemBuilder: (context, index) {
                              var listSong = songs[index];

                              return CustomListTile(
                                  index: index,
                                  listSong: listSong,
                                  activeSong: activeSong,
                                  onTaped: () {
                                    ref.read(playerProvider.notifier).state =
                                        index;
                                  });
                            }),
                      ]))
                    ],
                  )),
              const Spacer(),
              MultiMusicPlayer(playList: songs)
              // ElevatedButton(onPressed: () {}, child: const Text('Hens'))
            ],
          ),
        )),
      ),
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
    var image = getImage(
      playList.imageUrl,
      width: MediaQuery.of(context).size.height * 0.3,
      height: MediaQuery.of(context).size.height * 0.3,
    );
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: image,
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
