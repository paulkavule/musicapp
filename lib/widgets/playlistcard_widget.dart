import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/playlist_model.dart';
import '../utilities/helpers.dart';

class PlayListCard extends StatelessWidget {
  const PlayListCard(
      {Key? key,
      required this.playList,
      this.homeScreen = true,
      required this.btnClicked})
      : super(key: key);
  final bool homeScreen;
  final PlayList playList;
  final Function btnClicked;

  @override
  Widget build(BuildContext context) {
    var image = getImage(playList.imageUrl);

    return InkWell(
      onTap: () {
        Get.toNamed("/playlist", arguments: playList);
      },
      child: Container(
        height: 75,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.brown.shade800.withOpacity(0.85),
            borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: image),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playList.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${playList.songs?.length} song(s)',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
            homeScreen
                ? IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.play_circle,
                      color: Colors.transparent,
                    ))
                : IconButton(
                    onPressed: () {
                      btnClicked();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ))
          ],
        ),
      ),
    );
  }
}
