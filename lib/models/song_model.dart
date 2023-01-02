import 'package:hive/hive.dart';

part 'song_model.g.dart';

@HiveType(typeId: 1)
class Song {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String url;
  @HiveField(3)
  String coverUrl;
  @HiveField(8)
  DateTime addDate = DateTime.now();
  @HiveField(4)
  bool isFavourite;
  @HiveField(5)
  List<String> playList = [];
  @HiveField(6)
  String genera;
  @HiveField(7)
  int id;
  @HiveField(9)
  String uuid;
  Song(
      {required this.title,
      required this.description,
      required this.url,
      required this.coverUrl,
      this.isFavourite = false,
      this.genera = "",
      this.uuid = "",
      this.id = 0});

  static List<Song> songs = [
    Song(
        coverUrl: "assets/images/glass.png",
        title: "Glass",
        url: "assets/music/glass.mp3",
        description: "Glass"),
    Song(
        coverUrl: "assets/images/illusions.png",
        title: "Illussions",
        url: "assets/music/illussions.mp3",
        description: "Illussions"),
    Song(
        coverUrl: "assets/images/pray.png",
        title: "Pray",
        url: "assets/music/pray.mp3",
        description: "Praying"),
  ];
}
