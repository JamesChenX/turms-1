import 'package:flutter/material.dart';

import 'player_state.dart';
import 'youtube_player_controller.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({
    super.key,
    required this.controller,
  });

  final YoutubePlayerController controller;

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton>
    with TickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 300),
    );
    widget.controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    _animController.dispose();
    super.dispose();
  }

  void _controllerListener() {
    if (!mounted) {
      return;
    }
    setState(() {});
    if (widget.controller.value.isPlaying) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.controller.value;
    final state = value.playerState;

    if (_showPlayPause(state)) {
      final visible = state == PlayerState.cued ||
          !value.isPlaying ||
          value.isControlsVisible;

      return Visibility(
        visible: visible,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: () => _togglePlayPause(state),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _animController.view,
              color: Colors.white,
              size: 60.0,
            ),
          ),
        ),
      );
    }
    if (widget.controller.value.hasError) {
      return const SizedBox();
    }
    return const SizedBox.square(
      dimension: 70,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    );
  }

  void _togglePlayPause(PlayerState state) {
    state == PlayerState.playing
        ? widget.controller.pause()
        : widget.controller.play();
  }

  bool _showPlayPause(PlayerState state) =>
      (!widget.controller.autoPlay && widget.controller.value.isReady) ||
      state == PlayerState.playing ||
      state == PlayerState.paused;
}
