import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:musicapp1/screens/home_screen.dart';
import 'package:musicapp1/screens/playlist_screen.dart';
import 'package:musicapp1/screens/song_screen.dart';

void main() {
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
        home: const HomeScreen(),
        getPages: [
          GetPage(name: "/", page: () => const HomeScreen()),
          GetPage(name: "/song", page: () => const SongScreen()),
          GetPage(name: "/playlist", page: () => const PlaylistScreen())
        ]);
  }
}
