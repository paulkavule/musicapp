import 'package:flutter/material.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/widgets/widgets.dart';

import '../models/song_model.dart';
import '../services/song_svc.dart';
import '../widgets/widgets.dart';

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({Key? key}) : super(key: key);
  final songSvc = getIT<ISongService>();
  @override
  Widget build(BuildContext context) {
    // List<Song> list = list.add(Song(titlte: titlte, description: description, url: url, coverUrl: coverUrl))
    return Container(
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
          title: const Text('Favourites'),
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<List<Song>>(
                  future: songSvc.getFavouriteSongs(),
                  builder: (context, playList) {
                    // var songList = playList ?? List<Song>;

                    if (playList.hasData == false) {
                      return const NoData(
                          title: 'Ops',
                          message: 'No favourites have been selected yet!');
                    }
                    if (playList.data!.isEmpty) {
                      return const NoData(
                          title: 'Ops',
                          message: 'No favourites have been selected yet!');
                    }

                    return SongPlayListWidget(songsList: playList.data!);
                  })),
        ),
      ),
    );
  }
}
