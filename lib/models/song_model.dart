class Song{
  final String titlte;
  final String description;
  final String url;
  final String coverUrl;

  Song({
    required this.titlte,
    required this.description,
    required this.url,
    required this.coverUrl
  });


  static List<Song> songs = [
    Song(coverUrl: "assets/images/glass.png", titlte: "Glass", url: "assets/music/glass.mp3",description: "Glass"),
    Song(coverUrl: "assets/images/illusions.png", titlte: "Illussions", url: "assets/music/illussions.mp3",description: "Illussions"),
    Song(coverUrl: "assets/images/pray.png", titlte: "Pray", url: "assets/music/pray.mp3",description: "Praying"),
  ];


}