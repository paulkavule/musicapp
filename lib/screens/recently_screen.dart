import 'package:flutter/material.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/widgets/widgets.dart';

import '../models/song_model.dart';
import '../services/song_svc.dart';
import '../widgets/song_widget.dart';

class RecentlyAddScreen extends StatefulWidget {
  const RecentlyAddScreen({Key? key}) : super(key: key);

  @override
  State<RecentlyAddScreen> createState() => _RecentlyAddScreenState();
}

class _RecentlyAddScreenState extends State<RecentlyAddScreen> {
  ISongService get playSvc => getIT<ISongService>();
  var showList = true;
  @override
  Widget build(BuildContext context) {
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
          title: const Text('Recently added'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    showList = !showList;
                  });
                },
                icon: Icon(
                  showList ? Icons.list_rounded : Icons.grid_view_rounded,
                  color: Colors.white,
                ))
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FutureBuilder<List<Song>>(
              future: playSvc.getMostRecentSongs(),
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return const Text('Data');
                }
                var songs = snapshot.data!;
                print('Songs => ${songs.length}');
                if (showList == true) {
                  return SongPlayListWidget(
                    songsList: songs,
                  );
                }
                return GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  children: List.generate(songs.length, (index) {
                    return SongCard(song: songs[index]);
                  }),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
