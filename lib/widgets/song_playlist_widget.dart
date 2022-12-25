import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp1/utilities/helpers.dart';

import '../models/song_model.dart';
import '../providers/app_provider.dart';
import 'multimusic_player_widget.dart';

class SongPlayListWidget extends ConsumerStatefulWidget {
  const SongPlayListWidget({
    Key? key,
    required this.songsList,
  }) : super(key: key);
  // final songSv = getIT<ISongService>();
  final List<Song> songsList;

  @override
  _SongPlayListWidgetState createState() => _SongPlayListWidgetState();
}

class _SongPlayListWidgetState extends ConsumerState<SongPlayListWidget> {
  @override
  Widget build(BuildContext context) {
    final int activeSong = ref.watch(playerProvider);

    // ref.listen<int>(playerProvider, (prev, next) {
    //   print('playscreen => next index is   $next');
    // });

    return Stack(children: <Widget>[
      Container(
        constraints: const BoxConstraints.expand(),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.songsList.length,
            itemBuilder: (context, index) {
              var listSong = widget.songsList[index];
              print(
                  'ListView - Song: ${listSong.titlte}, Favourite: ${listSong.isFavourite}');
              return ListTile(
                leading: Text(
                  '${index + 1}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                title: Text(
                  widget.songsList[index].titlte,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${widget.songsList[index].description.truncate(20, placeholder: '...')} ø',
                ),
                trailing: PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.favorite,
                              color: listSong.isFavourite
                                  ? Colors.amber.shade800
                                  : Colors.deepPurple),
                          const SizedBox(width: 10),
                          Text(
                            "Add to favourite",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          const Icon(Icons.playlist_remove,
                              color: Colors.deepPurple),
                          const SizedBox(width: 10),
                          Text(
                            "Remove from playlist",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Row(
                        children: [
                          const Icon(Icons.delete_forever_rounded,
                              color: Colors.deepPurple),
                          const SizedBox(width: 10),
                          Text(
                            "Remove from disk",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert),
                  elevation: 2,
                  onSelected: (value) {
                    switch (value) {
                      case 1:
                        print('Uuid: ${listSong.titlte}, index: $index');
                        // widget.songSv.markUnmarkAsFavourite(
                        //     listSong.id, !listSong.isFavourite);
                        break;
                    }
                  },
                ), //const Icon(Icons.more_vert, color: Colors.white),
                selected: index == activeSong,
                selectedColor: Colors.orange,
                onTap: () {
                  ref.read(playerProvider.notifier).state = index;

                  // playingSong(index);
                },
              );
            }),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: MultiMusicPlayer(playList: widget.songsList),
      ),
    ]);
  }
}
