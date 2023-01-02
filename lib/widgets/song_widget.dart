import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/song_model.dart';
import '../utilities/helpers.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    Key? key,
    required this.song,
  }) : super(key: key);

  final Song song;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('/song', arguments: song);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: getDecorationImage(song.coverUrl)
                  //image: getImage(song.coverUrl) as DecorationImage
                  //DecorationImage(
                  //   image: AssetImage(
                  //     song.coverUrl
                  //   ),
                  //   fit: BoxFit.cover
                  // )
                  ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: 50,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title.truncate(8, placeholder: '...'),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.purple, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        song.description.truncate(10, placeholder: '...'),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const Icon(
                    Icons.play_circle,
                    color: Colors.deepPurple,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
