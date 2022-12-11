

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    Key? key,
    required this.player,
  }) : super(key: key);

  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      
      children: [
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot){
            return IconButton(onPressed: (){
              if(player.hasPrevious){
                player.seekToPrevious();
              }
            }, 
            icon: const Icon(Icons.skip_previous,color: Colors.white, size: 45,));
          }),


        StreamBuilder(
          stream: player.playerStateStream,
          builder: (context, snapshot){
            if(snapshot.hasData){
              final playerState = snapshot.data;
              final processState = (playerState! as PlayerState).processingState;

              if(processState  == ProcessingState.loading || processState == ProcessingState.buffering){
                return Container(width: 75, height: 75, margin: const EdgeInsets.all(10.0), child: const CircularProgressIndicator(),);
              }else if(player.playing == false){
                return IconButton(onPressed: () => player.play(), icon: const Icon(Icons.play_circle, color: Colors.white, size: 75,));
              }else if(processState != ProcessingState.completed){
                return IconButton(onPressed: () => player.pause(), icon: const Icon(Icons.pause_circle, color: Colors.white, size: 75,));
              }
              return IconButton(onPressed: () => player.seek(Duration.zero, index: player.effectiveIndices!.first ), icon: const Icon(Icons.replay_circle_filled_outlined, color: Colors.white, size: 75,));
            }else{
              return CircularProgressIndicator();
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot){
            return IconButton(onPressed: (){
              if(player.hasNext){
                player.seekToNext();
              }
            }, 
            icon: const Icon(Icons.skip_next,color: Colors.white, size: 45,));
          }),


      ],
    );
  }
}