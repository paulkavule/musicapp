import 'dart:math';

import 'package:flutter/material.dart';

class SeekBarDto {
  final Duration position;
  final Duration duration;

  SeekBarDto(this.position, this.duration);
}

class SeekBar extends StatefulWidget {
  const SeekBar(
      {Key? key,
      required this.position,
      required this.duration,
      this.onChanged,
      this.onChangEnd,
      this.showTime = true})
      : super(key: key);
  final bool showTime;
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangEnd;

  @override
  State<SeekBar> createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  String formatedDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    }

    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padRight(2, '0');

    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.showTime ? formatedDuration(widget.position) : ''),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(
                    disabledThumbRadius: 4, enabledThumbRadius: 4),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white.withOpacity(0.2),
                thumbColor: Colors.white,
                overlayColor: Colors.white),
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(
                  _dragValue ?? widget.position.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  // print('Triggered ${_dragValue}');
                  _dragValue = value;
                });

                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangEnd != null) {
                  widget.onChangEnd!(Duration(milliseconds: value.round()));
                  _dragValue = null;
                }
              },
            ),
          ),
        ),
        Text(widget.showTime ? formatedDuration(widget.duration) : '')
      ],
    );
  }
}
