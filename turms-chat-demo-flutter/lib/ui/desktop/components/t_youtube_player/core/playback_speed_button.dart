import 'package:flutter/material.dart';

import 'playback_rate.dart';
import 'youtube_player_controller.dart';

class PlaybackSpeedButton extends StatefulWidget {
  const PlaybackSpeedButton({
    super.key,
    required this.controller,
  });

  final YoutubePlayerController controller;

  @override
  State<PlaybackSpeedButton> createState() => _PlaybackSpeedButtonState();
}

class _PlaybackSpeedButtonState extends State<PlaybackSpeedButton> {
  @override
  Widget build(BuildContext context) => PopupMenuButton<double>(
        onSelected: widget.controller.setPlaybackRate,
        tooltip: 'PlayBack Rate',
        itemBuilder: (context) => [
          _popUpItem('2.0x', PlaybackRate.twice),
          _popUpItem('1.75x', PlaybackRate.oneAndAThreeQuarter),
          _popUpItem('1.5x', PlaybackRate.oneAndAHalf),
          _popUpItem('1.25x', PlaybackRate.oneAndAQuarter),
          _popUpItem('Normal', PlaybackRate.normal),
          _popUpItem('0.75x', PlaybackRate.threeQuarter),
          _popUpItem('0.5x', PlaybackRate.half),
          _popUpItem('0.25x', PlaybackRate.quarter),
        ],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: Image.asset(
            // TODO
            'assets/speedometer.webp',
            package: 'youtube_player_flutter',
            width: 20.0,
            height: 20.0,
            color: Colors.white,
          ),
        ),
      );

  PopupMenuEntry<double> _popUpItem(String text, double rate) =>
      CheckedPopupMenuItem(
        checked: widget.controller.value.playbackRate == rate,
        value: rate,
        child: Text(text),
      );
}
