import 'package:flutter/material.dart';
import 'package:musicapp1/models/playlist_model.dart';

import '../models/song_model.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopHeader(),
                SectionHeader(title: 'Trending music'),
                SizedBox(height: 20,),
                TrendingSection(),
                SizedBox(height: 20,),
                SectionHeader(title: 'Playlists'),
                SizedBox(height: 20,),
                PlayListSection()
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}

class PlayListSection extends StatelessWidget {
  const PlayListSection({
    Key? key }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    List<PlayList> playLists = PlayList.playList;
    return ListView.builder(
      itemCount: playLists.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index){
        return PlayListCard(playList: playLists[index]);
      })
    );
  }
}


class TrendingSection extends StatelessWidget {
  const TrendingSection({
    Key? key
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
     
    List<Song> songs = Song.songs;
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return SongCard(song: songs[index]);
        },
      ),
    );
  }
}


class TopHeader extends StatelessWidget{
  const TopHeader({Key?key}):super(key:key);
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome', style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(
                  height: 5,
                ),
                Text('Enjoy your favorite music',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(
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
                        prefixIcon:
                            Icon(Icons.search, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none))),
                            SizedBox(height: 10,),
        ],
      ),
    );
  }
  
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.deepPurple.shade800,
      unselectedItemColor: Colors.grey.shade400,
      selectedItemColor: Colors.white,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: 'Play'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_outline), label: 'Profile')
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const Icon(Icons.grid_view_rounded),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://images.freeimages.com/images/large-previews/889/chef-1318790.jpg'
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
