

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp1/models/song_model.dart';
import 'package:musicapp1/widgets/playbutton_widget.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../models/seekbar_model.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({ Key? key }) : super(key: key);
  
  @override
  State<SongScreen> createState() => SongScreenState();
  
}

class SongScreenState extends State<SongScreen>{
  AudioPlayer player = AudioPlayer();
  Song song = Get.arguments ?? Song.songs[0];

  @override
  void initState(){
    super.initState();

    player.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          AudioSource.uri(
            Uri.parse('asset:///${song.url}')
          )
        ]
      )
    );
  }

  @override
  void dispose(){
    player.dispose();
    super.dispose();
  }

  Stream<SeekBarDto> get seekBarStream =>  
    rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarDto>(
      player.positionStream, 
      player.durationStream,
      (Duration pst, Duration? dur,){
        return SeekBarDto(pst, dur?? Duration.zero);
      }
    );
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            song.coverUrl,
            fit: BoxFit.cover,
          ),
          const BackgroundFilter(),
          MusicPlayer(song: song, seekBarStream: seekBarStream, player: player)
        ],
      ),
    );
  }
}

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({
    Key? key,
    required this.song,
    required this.seekBarStream,
    required this.player,
  }) : super(key: key);
  final Song song;
  final Stream<SeekBarDto> seekBarStream;
  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(song.titlte, style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold, color: Colors.white), ),
          const SizedBox(height: 10,),
          Text(song.description, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white), ),
          const SizedBox(height: 10,),
          StreamBuilder(
            stream : seekBarStream,
            builder: (context, snapshot) {
              final postionData = snapshot.data;
              // print('Duration: ${postionData?.duration} | position: ${postionData?.position}');
              return SeekBar(
                position: postionData?.position ?? Duration.zero, 
                duration: postionData?.duration ?? Duration.zero,
                onChangEnd: player.seek,
              );
            },
          ),
          PlayButton(player: player),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(onPressed: (){

              }, icon: const Icon(Icons.settings, color: Colors.white, size: 25,)),
              IconButton(onPressed: (){

              }, icon: const Icon(Icons.file_download, color: Colors.white, size: 25,))
            ],
          ),
        ],
      ),
    );
  }
}


class BackgroundFilter extends StatelessWidget {
  const BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstOut,
      shaderCallback: (rect){
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.0)
          ],
          stops: [0.0, 0.4, 0.6]
        ).createShader(rect);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade800
            ]
          )
        ),
      ),
    );
  }
}