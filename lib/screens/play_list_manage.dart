import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:musicapp1/dicontainer.dart';
import 'package:musicapp1/screens/home_screen.dart';
// import 'package:musicapp1/models/playlist_model.dart';
import 'package:musicapp1/services/song_svc.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import '../models/song_model.dart';
import '../services/playlist_svc.dart';
import '../utilities/helpers.dart';

class PlayListManage extends StatelessWidget {
  PlayListManage({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
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
          body: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              onTap: () {
                print('on Taped:');
              },
              decoration: InputDecoration(hintText: 'Email'),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Email required';
                }
              },
            )
          ],
        ),
      )),
    );
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
  String coverUrl = "", playlistName = "";
  var songSvc = getIT<ISongService>();
  var playListSvc = getIT<IPlaylistService>();
  // final unameField = TextEditingController();

  // Future<String> createFolder(String cow) async {
  //   final dir = Directory((Platform.isAndroid
  //               ? await getExternalStorageDirectory() //FOR ANDROID
  //               : await getApplicationSupportDirectory() //FOR IOS
  //           )!
  //           .path +
  //       '/$cow');
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     await Permission.storage.request();
  //   }
  //   if ((await dir.exists())) {
  //     return dir.path;
  //   } else {
  //     dir.create();
  //     return dir.path;
  //   }
  // }

  void _pickFile() async {
    // var dirPath = await createFolder('Mubimba');

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    // type: FileType.custom,
    // allowedExtensions: ['mp3'],
    // allowMultiple: false);
    if (result == null || result.files.isEmpty) {
      return;
    }
    // print('DirPath, $dirPath');
    // var file = result.files.first;
    // print('FileData => Name: ${file.name}, Path:${file.path}');
    // result.files.where((ff) => ff.)
    for (var fl in result.files) {
      var filePath = fl.path!;
      var mtype = lookupMimeType(filePath);
      if (mtype == null) {
        continue;
      }
      if (!(mtype.startsWith('audio') || mtype.startsWith('image'))) {
        continue;
      }
      final dir = Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory(); //FOR IOS

      var file = File(filePath);
      var fpath = '${dir!.path}/${fl.name}';
      await file.copy(fpath);

      if (mtype.startsWith('image')) {
        coverUrl = fpath;
        continue;
      }

      // print('Song=> mimetype:$mtype , path: ${file.path}');

      // print('path1: ${fl.path}');
      // print('path2: ${file.absolute.path}\n\n');
      // print('path3: ${Uri.dataFromString(file.path)}\n\n');
      setState(() {
        songList.add(Song(
            title: file.uri.pathSegments.last,
            uuid: const Uuid().v4(),
            description: file.path,
            url: fpath,
            coverUrl: coverUrl));
      });
    }
  }

  void _pickDirectory(BuildContext context) async {
    var directory = await FilePicker.platform.getDirectoryPath();
    if (directory == null) {
      return;
    }
    try {
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
              title: file.uri.pathSegments.last.capitalized(),
              description: file.path,
              url: file.path,
              coverUrl: coverUrl));
        });
        // print('FileData => Name: ${file.uri.pathSegments.last}, ');
      }
    } on FileSystemException catch (e) {
      // print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
        ),
      ));
    }
  }

  void _savePlayList() async {
    if (playlistName.isEmpty == false) {
      coverUrl =
          coverUrl.isEmpty ? "assets/images/music_placeholder.png" : coverUrl;

      await playListSvc.savePlayList(playlistName.capitalized(), coverUrl);
    }

    for (var data in songList) {
      data.playList = [playlistName.capitalized()];
      data.coverUrl = data.coverUrl.isEmpty
          ? "assets/images/music_placeholder.png"
          : data.coverUrl;
      await songSvc.saveSong(data);
    }
    // var playList= PlayList(title: _pltitle, imageUrl: coverUrl);
    // if(result.)
    final executed = playlistName.isNotEmpty || songList.isNotEmpty;
    Get.back(result: executed);
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
            Colors.brown.shade800.withOpacity(0.8),
            Colors.brown.shade200.withOpacity(0.8)
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
                  : () async {
                      if (playlistName.isEmpty) {
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
              TextField(
                  onChanged: (value) => {
                        setState(() {
                          playlistName = value;
                        })
                      },
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.black),
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
                    title: Text(songList[index].title),
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
                backgroundColor: Colors.brown,
                child: const Icon(Icons.file_copy),
              ),
              const SizedBox(
                width: 10,
              ),
              // FloatingActionButton(
              //   heroTag: 'btn2',
              //   onPressed: () {
              //     _pickDirectory(context);
              //   },
              //   backgroundColor: Colors.brown,
              //   child: const Icon(Icons.folder),
              // ),
            ]),
      ),
    );
  }
}
