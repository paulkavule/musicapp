import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'song_model.g.dart';

@HiveType(typeId: 1)
class Song {
  @HiveField(0)
  final String titlte;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String url;
  @HiveField(3)
  final String coverUrl;
  @HiveField(8)
  DateTime addDate = DateTime.now();
  @HiveField(4)
  bool isFavourite;
  @HiveField(5)
  String playList;
  @HiveField(6)
  String genera;
  @HiveField(7)
  String id;
  Song(
      {required this.titlte,
      required this.description,
      required this.url,
      required this.coverUrl,
      this.isFavourite = false,
      this.playList = "",
      this.genera = "",
      this.id = ""});

  static List<Song> songs = [
    Song(
        coverUrl: "assets/images/glass.png",
        titlte: "Glass",
        url: "assets/music/glass.mp3",
        description: "Glass"),
    Song(
        coverUrl: "assets/images/illusions.png",
        titlte: "Illussions",
        url: "assets/music/illussions.mp3",
        description: "Illussions"),
    Song(
        coverUrl: "assets/images/pray.png",
        titlte: "Pray",
        url: "assets/music/pray.mp3",
        description: "Praying"),
  ];
}
