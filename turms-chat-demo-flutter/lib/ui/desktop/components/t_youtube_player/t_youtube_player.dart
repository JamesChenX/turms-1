import 'package:flutter/material.dart';

import '../../../themes/sizes.dart';
import 'core/duration_widgets.dart';
import 'core/play_pause_button.dart';
import 'core/playback_speed_button.dart';
import 'core/progress_bar.dart';
import 'core/raw_youtube_player.dart';
import 'core/thumbnail_quality.dart';
import 'core/video_metadata.dart';
import 'core/youtube_player_controller.dart';

class TYoutubePlayer extends StatefulWidget {
  const TYoutubePlayer({
    super.key,
    required this.controller,
    this.width,
    this.aspectRatio = 16 / 9,
    this.controlsTimeOut = const Duration(seconds: 3),
    this.onReady,
    this.onEnded,
    this.showVideoProgressIndicator = false,
  });

  final YoutubePlayerController controller;

  /// {@template youtube_player_flutter.width}
  /// Defines the width of the player.
  ///
  /// Default is devices's width.
  /// {@endtemplate}
  final double? width;

  /// {@template youtube_player_flutter.aspectRatio}
  /// Defines the aspect ratio to be assigned to the player. This property along with [width] calculates the player size.
  ///
  /// Default is 16 / 9.
  /// {@endtemplate}
  final double aspectRatio;

  /// {@template youtube_player_flutter.controlsTimeOut}
  /// The duration for which controls in the player will be visible.
  ///
  /// Default is 3 seconds.
  /// {@endtemplate}
  final Duration controlsTimeOut;

  /// {@template youtube_player_flutter.onReady}
  /// Called when player is ready to perform control methods like:
  /// play(), pause(), load(), cue(), etc.
  /// {@endtemplate}
  final VoidCallback? onReady;

  final void Function(VideoMetadata metadata)? onEnded;

  /// {@template youtube_player_flutter.showVideoProgressIndicator}
  /// Defines whether to show or hide progress indicator below the player.
  ///
  /// Default is false.
  /// {@endtemplate}
  final bool showVideoProgressIndicator;

  /// Converts fully qualified YouTube Url to video id.
  ///
  /// If videoId is passed as url then no conversion is done.
  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains('http') && (url.length == 11)) {
      return url;
    }
    if (trimWhitespaces) {
      url = url.trim();
    }

    for (final exp in [
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(
          r'^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(r'^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$')
    ]) {
      final match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }
    return null;
  }

  static String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.standard,
    bool webp = true,
  }) =>
      webp
          ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
          : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';

  @override
  State<TYoutubePlayer> createState() => _TYoutubePlayerState();
}

class _TYoutubePlayerState extends State<TYoutubePlayer> {
  late YoutubePlayerController _controller;

  late double _aspectRatio;
  bool _initialLoad = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller..addListener(listener);
    _aspectRatio = widget.aspectRatio;
  }

  @override
  void didUpdateWidget(TYoutubePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(listener);
    widget.controller.addListener(listener);
  }

  Future<void> listener() async {
    if (_controller.value.isReady && _initialLoad) {
      _initialLoad = false;
      if (_controller.autoPlay) {
        _controller.play();
      }
      widget.onReady?.call();
      if (_controller.controlsVisibleAtStart) {
        _controller.updateValue(isControlsVisible: true);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.black,
        child: Container(
          color: Colors.black,
          width: widget.width ?? MediaQuery.of(context).size.width,
          child: AspectRatio(
            aspectRatio: _aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                RawYoutubePlayer(
                  key: widget.key,
                  controller: _controller,
                  onEnded: () {
                    final metadata = _controller.metadata;
                    widget.onEnded?.call(metadata);
                  },
                ),
                AnimatedOpacity(
                  opacity: _controller.value.isPlaying ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: _buildThumbnail(),
                ),
                if (!_controller.value.isFullScreen &&
                    _controller.value.position >
                        const Duration(milliseconds: 100) &&
                    !_controller.value.isControlsVisible &&
                    widget.showVideoProgressIndicator)
                  Positioned(
                    bottom: -7.0,
                    left: -7.0,
                    right: -7.0,
                    child: IgnorePointer(
                      child: ProgressBar(
                        controller: _controller,
                        isExpanded: true,
                        playedColor: Colors.white,
                        bufferedColor: Colors.white70,
                        backgroundColor: Colors.white60,
                        handleColor: Colors.white,
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: _controller.value.isControlsVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Row(
                      children: [
                        const SizedBox(width: 14.0),
                        CurrentPositionIndicator(
                          controller: _controller,
                        ),
                        const SizedBox(width: 8.0),
                        ProgressBar(
                          controller: _controller,
                          isExpanded: true,
                          playedColor: Colors.white,
                          bufferedColor: Colors.white70,
                          backgroundColor: Colors.white60,
                          handleColor: Colors.white,
                        ),
                        RemainingDurationIndicator(
                          controller: _controller,
                        ),
                        PlaybackSpeedButton(
                          controller: _controller,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                    child: PlayPauseButton(
                  controller: _controller,
                )),
                if (_controller.value.hasError) _buildError(),
              ],
            ),
          ),
        ),
      );

  Widget _buildError() => Container(
        color: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
                Sizes.sizedBoxW4,
                Expanded(
                  child: Text(
                    formatError(
                      _controller.value.errorCode,
                      videoId: _controller.metadata.videoId.isNotEmpty
                          ? _controller.metadata.videoId
                          : _controller.initialVideoId,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Error Code: ${_controller.value.errorCode}',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      );

  Widget _buildThumbnail() => Image.network(
        TYoutubePlayer.getThumbnail(
          videoId: _controller.metadata.videoId.isEmpty
              ? _controller.initialVideoId
              : _controller.metadata.videoId,
        ),
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : Container(color: Colors.black),
        errorBuilder: (context, _, __) => Image.network(
          TYoutubePlayer.getThumbnail(
            videoId: _controller.metadata.videoId.isEmpty
                ? _controller.initialVideoId
                : _controller.metadata.videoId,
            webp: false,
          ),
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : Container(color: Colors.black),
          errorBuilder: (context, _, __) => Container(),
        ),
      );
}

String formatError(int errorCode, {String videoId = ''}) => switch (errorCode) {
      1 => 'Invalid Video ID = $videoId',
      2 => 'The request contains an invalid parameter value.',
      5 => 'The requested content cannot be played by the player.',
      100 => 'The video requested was not found.',
      101 => 'Playback on other apps has been disabled by the video owner.',
      105 => 'Exact error cannot be determined for this video.',
      150 => 'Playback on other apps has been disabled by the video owner.',
      _ => 'Unknown Error'
    };
