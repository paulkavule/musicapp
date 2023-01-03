import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/services/playlist_svc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/playlist_model.dart';
import '../providers/app_provider.dart';
import '../widgets/playlistcard_widget.dart';

class PlaylistDashboard extends ConsumerStatefulWidget {
  const PlaylistDashboard({Key? key}) : super(key: key);

  @override
  PlaylistDashboardState createState() => PlaylistDashboardState();
}

class PlaylistDashboardState extends ConsumerState<PlaylistDashboard> {
  var playlistSvc = getIT<IPlaylistService>();
  // List<PlayList> playLists = [];

  @override
  Widget build(BuildContext context) {
    var playLists = ref.watch(appPlayList);

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
          title: const Text('Playlist'),
          actions: [
            IconButton(
                onPressed: () async {
                  // await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>const PlayListManageScreen(),
                  //     ));
                  await Get.toNamed('/mngplaylist');
                  await playlistSvc.getPlayList().then((value) {
                    ref.read(appPlayList.notifier).refereshData(value);
                  });

                  // var result = (await Get.toNamed('/mngplaylist')) as bool;
                  // print("result: $result, ${result.runtimeType}");
                  // if (result) {
                  //   setState(() {
                  //     playlistSvc.getPlayList().then((value) {
                  //       ref.read(appPlayList.notifier).state = value;
                  //     });
                  //   });
                  // }
                },
                icon: const Icon(
                  Icons.add_circle_rounded,
                  size: 30,
                ))
          ],
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
                  playLists = snapshot.data!;
                  return ListView.builder(
                      itemCount: playLists.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        return PlayListCard(
                          playList: playLists[index],
                          homeScreen: false,
                          btnClicked: () {
                            //
                            setState(() {
                              playlistSvc.deleteItem(playLists[index].uuid!);
                              ref
                                  .read(appPlayList.notifier)
                                  .removeData(playLists[index].uuid!);
                            });
                          },
                        );
                      }));
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

//  return ListView.separated(
//                     shrinkWrap: true,
//                     itemCount: playList.length,
//                     separatorBuilder: (context, index) => Divider(
//                       color: Colors.grey.shade600,
//                     ),
//                     itemBuilder: (context, index) {
//                       print(
//                           '\n\nListSize: ${playList.length} path: ${playList[index]}');
//                       if (playList.isEmpty) {
//                         return const Text('Please wait');
//                       }

//                       var image = GetImage(playList[index].imageUrl);

//                       return ListTile(
//                         onTap: () {},
//                         leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: image),
//                         title: Text(playList[index].title),

//                         // tileColor: Colors.deepPurple.shade700,
//                         horizontalTitleGap: 2.3,
//                         // shape: ShapeBorder(widget: SizedBox(height: 100,)),
//                         // subtitle: const Text('Hellos'),
//                         trailing: IconButton(
//                           onPressed: () {
//                             print(
//                                 'Deleting ${playList[index].uuid} -- ${playList[index].title} -- $index');

//                             playlistSvc.deleteItem(playList[index].uuid!);
//                             setState(() {
//                               playList = playList
//                                   .where(
//                                       (itm) => itm.uuid != playList[index].uuid)
//                                   .toList();
//                             });
//                           },
//                           icon: const Icon(
//                             Icons.delete,
//                             color: Colors.white,
//                           ),
//                         ),
//                       );
//                     },
//                   );
