import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/services/song_svc.dart';
// import 'package:path_provider/path_provider.dart' as pather;
import '../models/song_model.dart';
import '../services/playlist_svc.dart';
import '../utilities/helpers.dart';

class PlayListManage extends StatelessWidget {
  const PlayListManage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PlayListManageScreen extends StatefulWidget {
  const PlayListManageScreen({Key? key}) : super(key: key);

  @override
  State<PlayListManageScreen> createState() => _PlayListManageStateScreen();
}

class _PlayListManageStateScreen extends State<PlayListManageScreen> {
  List<Song> songList = [];
  bool enableCtrls = false;
  String coverUrl = "";
  var songSvc = getIT<ISongService>();
  var playListSvc = getIT<IPlaylistService>();
  final unameField = TextEditingController();
  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    // type: FileType.custom,
    // allowedExtensions: ['mp3'],
    // allowMultiple: false);
    if (result == null || result.files.single.path == null) {
      return;
    }
    print('File gotten');
    // var file = result.files.first;
    // print('FileData => Name: ${file.name}, Path:${file.path}');
    var file = File(result.files.single.path!);

    if (file.path.split('.').last != "mp3") {
      return;
    }
    // final tagger = Audiotagger();
    // var tags = await tagger.readTagsAsMap(path: result.files.single.path!);
    // for (var key in tags!.keys) {
    //   print('Key: $key value: ${tags[key]}');
    // }
    setState(() {
      songList.add(Song(
          titlte: file.uri.pathSegments.last,
          description: file.path,
          url: file.path,
          coverUrl: coverUrl));
    });
  }

  void _pickDirectory() async {
    var directory = await FilePicker.platform.getDirectoryPath();
    if (directory == null) {
      return;
    }

    var dir = Directory(directory);
    var files = await dir.list().toList();
    for (var fileInt in files) {
      if (fileInt.path.split('.').last.toLowerCase() == 'png') {
        coverUrl = fileInt.path;
        break;
      }
    }

    // if (coverPhoto.path.length > 10) {
    //   coverUrl = coverPhoto.path;
    // }

    for (var fileInst in files) {
      if (Directory(fileInst.path).existsSync()) {
        continue;
      }
      var file = File(fileInst.path);

      if (file.path.split('.').last != "mp3") {
        continue;
      }

      setState(() {
        songList.add(Song(
            titlte: file.uri.pathSegments.last.capitalize(),
            description: file.path,
            url: file.path,
            coverUrl: coverUrl));
      });
      print('FileData => Name: ${file.uri.pathSegments.last}, ');
    }
  }

  void _savePlayList() {
    coverUrl =
        coverUrl.isEmpty ? "assets/images/music_placeholder.png" : coverUrl;

    if (unameField.text.isEmpty == false) {
      playListSvc.savePlayList(unameField.text.capitalize(), coverUrl);
    }
    for (var data in songList) {
      data.playList = [unameField.text.capitalize()];
      data.coverUrl = data.coverUrl.isEmpty
          ? "assets/images/music_placeholder.png"
          : data.coverUrl;
      songSvc.saveSong(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    enableCtrls = songList.isNotEmpty;
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
        appBar: AppBar(
          title: const Text('Create Playlist'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: enableCtrls == false
                  ? null
                  : () {
                      if (unameField.text.isEmpty) {
                        showCupertinoDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return CupertinoAlertDialog(
                                title: const Text(
                                    'Please Confirm, playlist name not specified'),
                                content: const Text(
                                    'Are you sure you want to add songs but not to a specific playlist'),
                                actions: [
                                  // The "Yes" button
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      _savePlayList();
                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    isDefaultAction: true,
                                    isDestructiveAction: true,
                                    child: const Text('Yes'),
                                  ),
                                  // The "No" button
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    isDefaultAction: false,
                                    isDestructiveAction: false,
                                    child: const Text('No'),
                                  )
                                ],
                              );
                            });
                      } else {
                        _savePlayList();
                      }
                    },
              icon: Icon(
                Icons.save,
                color: enableCtrls ? Colors.white : Colors.grey.shade400,
              ),
              disabledColor: Colors.deepPurple.shade400,
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              // Text(
              //   'Create PlayList',
              //   style: Theme.of(context).textTheme.headline6,
              // ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.black),
                  controller: unameField,
                  enabled: enableCtrls,
                  decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor:
                          enableCtrls ? Colors.white : Colors.grey.shade300,
                      hintText: 'Playlist name',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none))),
              const SizedBox(
                height: 30,
              ),

              ListView.builder(
                shrinkWrap: true,
                itemCount: songList.length,
                itemBuilder: (context, index) {
                  if (songList.isEmpty) {
                    return const Text('Please wait');
                  }
                  var image = getImage(songList[index].coverUrl);

                  return ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10), child: image),
                    title: Text(songList[index].titlte),
                    // subtitle: const Text('Hellos'),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          songList.removeWhere(
                              (song) => song.uuid == songList[index].uuid);
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
        floatingActionButton: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'btn1',
                onPressed: () {
                  _pickFile();
                },
                backgroundColor: Colors.deepPurple,
                child: const Icon(Icons.file_copy),
              ),
              const SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                heroTag: 'btn2',
                onPressed: () {
                  _pickDirectory();
                },
                backgroundColor: Colors.deepPurple,
                child: const Icon(Icons.folder),
              ),
            ]),
      ),
    );
  }
}
