import 'package:flutter/material.dart';
import 'package:musicapp1/utilities/helpers.dart';

import '../models/song_model.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.index,
    required this.listSong,
    required this.activeSong,
    required this.onTaped,
  }) : super(key: key);

  final int index;
  final Song listSong;
  final int activeSong;
  final Function onTaped;
  // final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        // minLeadingWidth: 10,
        leading: Text(
          '${index + 1}',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        title: Text(
          listSong.title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${listSong.description.truncate(20, placeholder: '...')} ø',
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
                  const Icon(Icons.playlist_remove, color: Colors.deepPurple),
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
                print('Uuid: ${listSong.title}, index: $index');
                // widget.songSv.markUnmarkAsFavourite(
                //     listSong.id, !listSong.isFavourite);
                break;
            }
          },
        ), //const Icon(Icons.more_vert, color: Colors.white),
        selected: index == activeSong,
        selectedColor: Colors.orange,
        onTap: () {
          onTaped();
        }
        // () {
        //   ref.read(playerProvider.notifier).state = index;

        //   // playingSong(index);
        // },
        );
  }
}
