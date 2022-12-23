import 'package:flutter/material.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/widgets/widgets.dart';

import '../models/song_model.dart';
import '../services/song_svc.dart';

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({Key? key}) : super(key: key);
  final songSvc = getIT<ISongService>();
  @override
  Widget build(BuildContext context) {
    // List<Song> list = list.add(Song(titlte: titlte, description: description, url: url, coverUrl: coverUrl))

    return FutureBuilder<List<Song>>(
        future: songSvc.getFavouriteSongs(),
        builder: (context, playList) {
          // var songList = playList ?? List<Song>;
          if (playList.connectionState == ConnectionState.waiting) {
            return const Text('Please wait...');
          }
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
                title: const Text('Favourites'),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SongPlayListWidget(songsList: playList.data!),
                ),
              ),
            ),
          );
        });
  }
}
