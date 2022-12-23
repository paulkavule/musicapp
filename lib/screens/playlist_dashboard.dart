import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/services/playlist_svc.dart';
import 'package:musicapp1/utilities/helpers.dart';

import '../models/playlist_model.dart';

class PlaylistDashboard extends StatefulWidget {
  PlaylistDashboard({Key? key}) : super(key: key);

  @override
  State<PlaylistDashboard> createState() => _PlaylistDashboardState();
}

class _PlaylistDashboardState extends State<PlaylistDashboard> {
  var playlistSvc = getIT<IPlaylistService>();
  List<PlayList> playList = [];

  @override
  Widget build(BuildContext context) {
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
          title: const Text('Playlist'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<List<PlayList>>(
                future: playlistSvc.getPlayList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData == false) {
                    return const Text('Please wait');
                  }
                  playList = snapshot.data!;
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: playList.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey.shade600,
                    ),
                    itemBuilder: (context, index) {
                      print(
                          '\n\nListSize: ${playList.length} path: ${playList[index]}');
                      if (playList.isEmpty) {
                        return const Text('Please wait');
                      }

                      var image = GetImage(playList[index].imageUrl);

                      return ListTile(
                        onTap: () {},
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: image),
                        title: Text(playList[index].title),

                        // tileColor: Colors.deepPurple.shade700,
                        horizontalTitleGap: 2.3,
                        // shape: ShapeBorder(widget: SizedBox(height: 100,)),
                        // subtitle: const Text('Hellos'),
                        trailing: IconButton(
                          onPressed: () {
                            print(
                                'Deleting ${playList[index].uuid} -- ${playList[index].title} -- $index');

                            playlistSvc.deleteItem(playList[index].uuid!);
                            setState(() {
                              playList = playList
                                  .where(
                                      (itm) => itm.uuid != playList[index].uuid)
                                  .toList();
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  );
                },
              )
              // ListView.builder(
              //   itemCount: ,
              //   itemBuilder: (context, index) => ListTile(
              //     title: ,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
