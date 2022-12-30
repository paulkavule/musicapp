import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/models/playlist_model.dart';
import 'package:musicapp1/providers/app_provider.dart';
import 'package:musicapp1/services/playlist_svc.dart';
import 'package:musicapp1/services/song_svc.dart';

import '../models/song_model.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  User get user {
    var user = Get.arguments;
    if (user == null) {
      Get.back();
    }
    return user as User;
  }

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
        appBar: CustomAppBar(
          user: user,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopHeader(),
                SectionHeader(
                  title: 'Recently added',
                  btnClicked: () => {Get.toNamed('/recentlyadded')},
                ),
                const SizedBox(height: 20),
                TrendingSection(),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'Playlists',
                  btnClicked: () => {Get.toNamed("/dataplaylist")},
                ),
                const SizedBox(height: 20),
                const PlayListSection()
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          user: user,
        ),
      ),
    );
  }
}

class PlayListSection extends ConsumerStatefulWidget {
  const PlayListSection({Key? key}) : super(key: key);

  @override
  PlayListSectionState createState() => PlayListSectionState();
}

class PlayListSectionState extends ConsumerState<PlayListSection>
    with WidgetsBindingObserver {
  IPlaylistService get plSvc => getIT<IPlaylistService>();
  List<PlayList> playLists = [];

  @override
  Widget build(BuildContext context) {
    playLists = ref.watch(appPlayList);

    return FutureBuilder<List<PlayList>>(
        future: plSvc.getPlayList(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return const Text('Please wait');
          }
          playLists = snapshot.data!.take(4).toList();
          return ListView.builder(
              itemCount: playLists.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: ((context, index) {
                return PlayListCard(
                  playList: playLists[index],
                  btnClicked: () {},
                );
              }));
        });
  }
}

class TrendingSection extends StatelessWidget {
  final songSvc = getIT<ISongService>();
  TrendingSection({Key? key}) : super(key: key);
//  List<Song> getList() async{
//   var songList = await songSvc.getMostPlayedSongs();
//   return songList;
//  }
  @override
  Widget build(BuildContext context) {
    // List<Song> songs = Song.songs;
    // var songList = List<Song>;

    return FutureBuilder<List<Song>>(
        future: songSvc.getMostRecentSongs(count: 4),
        builder: (context, snaphot) {
          if (snaphot.hasData == false) {
            return const SizedBox(
              height: 10,
            );
          }
          var songs = snaphot.data!;

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return SongCard(song: songs[index]);
              },
            ),
          );
        });
    // return SizedBox(
    //   height: MediaQuery.of(context).size.height * 0.25,
    //   child: ListView.builder(
    //     scrollDirection: Axis.horizontal,
    //     itemCount: songs.length,
    //     itemBuilder: (context, index) {
    //       return SongCard(song: songs[index]);
    //     },
    //   ),
    // );
  }
}

class TopHeader extends StatelessWidget {
  const TopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 5),
        Text('Enjoy your favorite music',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none))),
        const SizedBox(height: 10),
      ],
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key, required this.user})
      : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.brown.shade800.withOpacity(0.8),
      unselectedItemColor: Colors.grey.shade400,
      selectedItemColor: Colors.white,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        // BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: 'Play'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_outline), label: 'Profile')
      ],
      onTap: (index) {
        switch (index) {
          case 1:
            Get.toNamed("/favourite");
            break;
          case 2:
            Get.toNamed("/profile", arguments: user);
            break;
        }
      },
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const Icon(Icons.grid_view_rounded),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL!
                // 'https://images.freeimages.com/images/large-previews/889/chef-1318790.jpg'
                // 'https://cdn.pixabay.com/photo/2022/10/17/15/44/bird-7528089_960_720.jpg'
                ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
