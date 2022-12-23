import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/models/playlist_model.dart';
import 'package:musicapp1/models/song_model.dart';
import 'package:musicapp1/screens/favourite_screen.dart';
import 'package:musicapp1/screens/home_screen.dart';
import 'package:musicapp1/screens/play_list_manage.dart';
import 'package:musicapp1/screens/playlist_dashboard.dart';
import 'package:musicapp1/screens/playlist_screen.dart';
import 'package:musicapp1/screens/song_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await Hive.initFlutter();

  Hive.registerAdapter(SongAdapter());
  Hive.registerAdapter(PlayListAdapter());
  await Hive.openBox<Song>('songsdb');
  await Hive.openBox<PlayList>('playlistdb');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white, displayColor: Colors.white),
          primarySwatch: Colors.blue,
        ),
        home: PlaylistDashboard(),
        getPages: [
          GetPage(name: "/", page: () => const HomeScreen()),
          GetPage(name: "/song", page: () => SongScreen()),
          GetPage(name: "/playlist", page: () => const PlaylistScreen()),
          GetPage(name: "/favourite", page: () => FavouriteScreen()),
          GetPage(
              name: "/mngplaylist", page: () => const PlayListManageScreen()),
          GetPage(name: "/dataplaylist", page: () => PlaylistDashboard())
        ]);
  }
}
