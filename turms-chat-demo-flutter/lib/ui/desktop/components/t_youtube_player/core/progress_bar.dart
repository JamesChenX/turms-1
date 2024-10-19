import 'package:flutter/material.dart';

import 'youtube_player_controller.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({
    super.key,
    required this.controller,
    this.isExpanded = false,
    required this.backgroundColor,
    required this.playedColor,
    required this.bufferedColor,
    required this.handleColor,
  });

  final YoutubePlayerController controller;

  final bool isExpanded;

  final Color backgroundColor;

  final Color playedColor;

  final Color bufferedColor;

  final Color handleColor;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  Offset _touchPoint = Offset.zero;

  double _playedValue = 0.0;
  double _bufferedValue = 0.0;

  bool _touchDown = false;
  late Duration _position;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateProgress);
    _updateProgress();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateProgress);
    super.dispose();
  }

  void _updateProgress() {
    final controller = widget.controller;
    final totalDuration = controller.metadata.duration.inMilliseconds;
    if (mounted && !totalDuration.isNaN && totalDuration != 0) {
      final value = controller.value;
      _playedValue = value.position.inMilliseconds / totalDuration;
      _bufferedValue = value.buffered;
      setState(() {});
    }
  }

  void _setValue() {
    _playedValue = _touchPoint.dx / context.size!.width;
  }

  void _updateTouchPoint() {
    if (_touchPoint.dx <= 0) {
      _touchPoint = Offset(0, _touchPoint.dy);
    } else if (_touchPoint.dx >= context.size!.width) {
      _touchPoint = Offset(context.size!.width, _touchPoint.dy);
    }
  }

  void _seekToRelativePosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    _touchPoint = box.globalToLocal(globalPosition);
    _updateTouchPoint();
    final relative = _touchPoint.dx / box.size.width;
    _position = widget.controller.metadata.duration * relative;
    widget.controller.seekTo(_position, allowSeekAhead: false);
  }

  void _dragEndActions() {
    final controller = widget.controller
      ..updateValue(isControlsVisible: false, isDraggingProgressBar: false)
      ..seekTo(_position);
    _touchDown = false;
    setState(() {});
    controller.play();
  }

  Widget _buildBar() => GestureDetector(
        onHorizontalDragDown: (details) {
          widget.controller.updateValue(
              isControlsVisible: true, isDraggingProgressBar: true);
          _seekToRelativePosition(details.globalPosition);
          _setValue();
          _touchDown = true;
          setState(() {});
        },
        onHorizontalDragUpdate: (details) {
          _seekToRelativePosition(details.globalPosition);
          setState(_setValue);
        },
        onHorizontalDragEnd: (details) {
          _dragEndActions();
        },
        onHorizontalDragCancel: _dragEndActions,
        child: Container(
          color: Colors.transparent,
          constraints: const BoxConstraints.expand(height: 7.0 * 2),
          child: CustomPaint(
            painter: _ProgressBarPainter(
              progressWidth: 2.0,
              handleRadius: 7.0,
              playedValue: _playedValue,
              bufferedValue: _bufferedValue,
              backgroundColor: widget.backgroundColor,
              playedColor: widget.playedColor,
              bufferedColor: widget.bufferedColor,
              handleColor: widget.handleColor,
              touchDown: _touchDown,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) =>
      widget.isExpanded ? Expanded(child: _buildBar()) : _buildBar();
}

class _ProgressBarPainter extends CustomPainter {
  const _ProgressBarPainter({
    required this.progressWidth,
    required this.handleRadius,
    required this.playedValue,
    required this.bufferedValue,
    required this.backgroundColor,
    required this.playedColor,
    required this.bufferedColor,
    required this.handleColor,
    required this.touchDown,
  });

  final double progressWidth;
  final double handleRadius;
  final double playedValue;
  final double bufferedValue;

  final Color backgroundColor;
  final Color playedColor;
  final Color bufferedColor;
  final Color handleColor;

  final bool touchDown;

  @override
  bool shouldRepaint(_ProgressBarPainter old) =>
      playedValue != old.playedValue ||
      bufferedValue != old.bufferedValue ||
      touchDown != old.touchDown;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square
      ..strokeWidth = progressWidth;

    final centerY = size.height / 2.0;
    final barLength = size.width - handleRadius * 2.0;

    final startPoint = Offset(handleRadius, centerY);
    final endPoint = Offset(size.width - handleRadius, centerY);
    final playProgressOffset = Offset(
      barLength * playedValue + handleRadius,
      centerY,
    );
    final bufferProgressOffset = Offset(
      barLength * bufferedValue + handleRadius,
      centerY,
    );

    paint.color = backgroundColor;
    canvas.drawLine(startPoint, endPoint, paint);

    paint.color = bufferedColor;
    canvas.drawLine(startPoint, bufferProgressOffset, paint);

    paint.color = playedColor;
    canvas.drawLine(startPoint, playProgressOffset, paint);

    final handlePaint = Paint()
      ..isAntiAlias = true
      ..color = Colors.transparent;

    canvas.drawCircle(playProgressOffset, centerY, handlePaint);

    if (touchDown) {
      handlePaint.color = handleColor.withValues(alpha: 0.4);
      canvas.drawCircle(playProgressOffset, handleRadius * 3, handlePaint);
    }

    handlePaint.color = handleColor;
    canvas.drawCircle(playProgressOffset, handleRadius, handlePaint);
  }
}
