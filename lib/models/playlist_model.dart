import 'package:musicapp1/models/song_model.dart';

class PlayList{
  final String title;
  final List<Song> songs;
  final String imageUrl;

  PlayList({required this.title, required this.imageUrl, required this.songs});

  static List<PlayList> playList = [
    PlayList(
      title: "Kingdom", 
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Flag_of_Buganda.svg/1200px-Flag_of_Buganda.svg.png", 
      songs: Song.songs
      ),
      PlayList(
      title: "Faith", 
      imageUrl: "https://images.freeimages.com/images/large-previews/625/elaborate-church-1638554.jpg", 
      songs: Song.songs
      ),
      PlayList(
      title: "Nature", 
      imageUrl: "https://images.freeimages.com/images/large-previews/768/exploring-its-world-1641865.jpg", 
      songs: Song.songs
      )
  ];

}