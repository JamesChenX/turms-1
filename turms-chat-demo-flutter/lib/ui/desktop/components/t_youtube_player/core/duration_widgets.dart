import 'package:flutter/material.dart';

import 'duration_formatter.dart';
import 'youtube_player_controller.dart';

class CurrentPositionIndicator extends StatefulWidget {
  const CurrentPositionIndicator({super.key, required this.controller});

  final YoutubePlayerController controller;

  @override
  State<CurrentPositionIndicator> createState() =>
      _CurrentPositionIndicatorState();
}

class _CurrentPositionIndicatorState extends State<CurrentPositionIndicator> {
  @override
  void initState() {
    widget.controller.addListener(_updateState);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Text(
        formatMediaDuration(
          widget.controller.value.position.inMilliseconds,
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
      );
}

class RemainingDurationIndicator extends StatefulWidget {
  const RemainingDurationIndicator({super.key, required this.controller});

  final YoutubePlayerController controller;

  @override
  State<RemainingDurationIndicator> createState() =>
      _RemainingDurationIndicatorState();
}

class _RemainingDurationIndicatorState
    extends State<RemainingDurationIndicator> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Text(
        '- ${formatMediaDuration(
          (widget.controller.metadata.duration.inMilliseconds) -
              (widget.controller.value.position.inMilliseconds),
        )}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
      );
}
