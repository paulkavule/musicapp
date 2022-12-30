import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp1/widgets/custome_list_tile.dart';

import '../models/song_model.dart';
import '../providers/app_provider.dart';
import 'multimusic_player_widget.dart';

class SongPlayListWidget extends ConsumerStatefulWidget {
  const SongPlayListWidget(
      {Key? key, required this.songsList, this.playlistMaxHeight = 500})
      : super(key: key);
  // final songSv = getIT<ISongService>();
  final List<Song> songsList;
  final double playlistMaxHeight;
  @override
  SongPlayListWidgetState createState() => SongPlayListWidgetState();
}

class SongPlayListWidgetState extends ConsumerState<SongPlayListWidget> {
  onTapped(int index) {
    ref.read(playerProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context) {
    final int activeSong = ref.watch(playerProvider);

    // ref.listen<int>(playerProvider, (prev, next) {
    //   print('playscreen => next index is   $next');
    // });

    return Column(children: <Widget>[
      SizedBox(
        height: widget.playlistMaxHeight,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate(<Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  // padding: EdgeInsets.all(5),
                  // scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.songsList.length,
                  itemBuilder: (context, index) {
                    var listSong = widget.songsList[index];

                    return CustomListTile(
                        index: index,
                        listSong: listSong,
                        activeSong: activeSong,
                        onTaped: () {
                          ref.read(playerProvider.notifier).state = index;
                        });
                  }),
            ]))
          ],
        ),

        // ListView.builder(
        //     shrinkWrap: true,
        //     // padding: EdgeInsets.all(5),
        //     scrollDirection: Axis.vertical,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemCount: widget.songsList.length,
        //     itemBuilder: (context, index) {
        //       var listSong = widget.songsList[index];
        //       print(
        //           'ListView - Song: ${listSong.titlte}, Favourite: ${listSong.isFavourite}');
        //       if (listSong == null) {
        //         return const Text('Please wait');
        //       }
        //       return CustomListTile(
        //           index: index,
        //           listSong: listSong,
        //           activeSong: activeSong,
        //           onTaped: () {
        //             ref.read(playerProvider.notifier).state = index;
        //           });
        //     }),
      ),
      const Spacer(),
      MultiMusicPlayer(playList: widget.songsList)

      // Positioned(
      //   bottom: 0,
      //   right: 0,
      //   left: 0,
      //   child: MultiMusicPlayer(playList: widget.songsList),
      // ),
    ]);
  }
}
