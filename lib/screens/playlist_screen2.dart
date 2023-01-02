import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:musicapp1/models/playlist_model.dart';
import 'package:musicapp1/providers/app_provider.dart';
import 'package:musicapp1/screens/playlist_screen.dart';
import 'package:musicapp1/widgets/widgets.dart';

class PlaylistScreen2 extends ConsumerStatefulWidget {
  PlaylistScreen2({Key? key}) : super(key: key);
  PlayList playlist = Get.arguments;
  @override
  PlaylistScreen2State createState() => PlaylistScreen2State();
}

class PlaylistScreen2State extends ConsumerState<PlaylistScreen2> {
  PlayList playList = PlayList.playList[0];
  var activeSong = 0;
  @override
  void initState() {
    super.initState();

    // var player = ref.watch(auidoPlayer);
    // if (player.playing == true) {
    //   player.stop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    // var activeSong = ref.read(playerProvider);
    var songs = [...playList.songs!, ...playList.songs!, ...playList.songs!];
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.brown.shade800.withOpacity(0.8),
            Colors.brown.shade200.withOpacity(0.8),
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 200,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      PlaylistWidget(playList: playList),
                      ListView.builder(
                          shrinkWrap: true,
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

                                  setState(() {
                                    activeSong = index;
                                  });
                                });
                          }),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: PlaylistPlayer(
                playList: songs,
                startPlaying: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
