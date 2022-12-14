import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/models/playlist_model.dart';
import 'package:musicapp1/models/song_model.dart';
import 'package:musicapp1/screens/favourite_screen.dart';
import 'package:musicapp1/screens/first_screen.dart';
import 'package:musicapp1/screens/home_screen.dart';
import 'package:musicapp1/screens/play_list_manage.dart';
import 'package:musicapp1/screens/playlist_dashboard.dart';
import 'package:musicapp1/screens/playlist_screen.dart';
import 'package:musicapp1/screens/playlist_screen2.dart';
import 'package:musicapp1/screens/recently_screen.dart';
import 'package:musicapp1/screens/song_screen.dart';
import 'package:musicapp1/screens/test_screen.dart';
import 'package:musicapp1/screens/user_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.pkavule.mubimba',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(SongAdapter());
  Hive.registerAdapter(PlayListAdapter());
  await Hive.openBox<Song>('cpm_songsdb');
  await Hive.openBox<PlayList>('cpm_playlistdb');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white, displayColor: Colors.white),
          primarySwatch: Colors.blue,
        ),
        home: const FirstScreen(),
        getPages: [
          GetPage(name: "/", page: () => const FirstScreen()),
          GetPage(name: "/home", page: () => HomeScreen()),
          GetPage(name: "/song", page: () => SongScreen()),
          GetPage(name: "/playlist", page: () => PlaylistScreen2()),
          GetPage(name: "/favourite", page: () => FavouriteScreen()),
          GetPage(
              name: "/mngplaylist", page: () => const PlayListManageScreen()),
          GetPage(name: "/dataplaylist", page: () => const PlaylistDashboard()),
          GetPage(
              name: '/recentlyadded', page: () => const RecentlyAddScreen()),
          GetPage(name: '/profile', page: () => const UserProfileScreen())
        ]);
  }
}
