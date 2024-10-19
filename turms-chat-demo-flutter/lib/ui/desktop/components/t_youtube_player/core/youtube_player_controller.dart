import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'playback_rate.dart';
import 'player_state.dart';
import 'video_metadata.dart';

/// [ValueNotifier] for [YoutubePlayerController].
class YoutubePlayerValue {
  YoutubePlayerValue({
    this.isReady = false,
    this.isControlsVisible = false,
    this.hasPlayed = false,
    this.position = Duration.zero,
    this.buffered = 0.0,
    this.isPlaying = false,
    this.isFullScreen = false,
    this.volume = 100,
    this.playerState = PlayerState.unloaded,
    this.playbackRate = PlaybackRate.normal,
    this.playbackQuality,
    this.errorCode = 0,
    this.webViewController,
    this.isDraggingProgressBar = false,
    this.videoMetadata = const VideoMetadata(),
  });

  final bool isReady;

  final bool isControlsVisible;

  final bool hasPlayed;

  final Duration position;

  final double buffered;

  final bool isPlaying;

  final bool isFullScreen;

  final int volume;

  /// The current state of the player defined as [PlayerState].
  final PlayerState playerState;

  /// The current video playback rate defined as [PlaybackRate].
  final double playbackRate;

  /// Reports the error code as described [here](https://developers.google.com/youtube/iframe_api_reference#Events).
  ///
  /// See the onError Section.
  final int errorCode;

  final InAppWebViewController? webViewController;

  /// Returns true is player has errors.
  bool get hasError => errorCode != 0;

  /// Reports the current playback quality.
  final String? playbackQuality;

  final bool isDraggingProgressBar;

  final VideoMetadata videoMetadata;

  YoutubePlayerValue copyWith({
    bool? isReady,
    bool? isControlsVisible,
    bool? isLoaded,
    bool? hasPlayed,
    Duration? position,
    double? buffered,
    bool? isPlaying,
    bool? isFullScreen,
    int? volume,
    PlayerState? playerState,
    double? playbackRate,
    String? playbackQuality,
    int? errorCode,
    InAppWebViewController? webViewController,
    bool? isDraggingProgressBar,
    VideoMetadata? videoMetadata,
  }) =>
      YoutubePlayerValue(
        isReady: isReady ?? this.isReady,
        isControlsVisible: isControlsVisible ?? this.isControlsVisible,
        hasPlayed: hasPlayed ?? this.hasPlayed,
        position: position ?? this.position,
        buffered: buffered ?? this.buffered,
        isPlaying: isPlaying ?? this.isPlaying,
        isFullScreen: isFullScreen ?? this.isFullScreen,
        volume: volume ?? this.volume,
        playerState: playerState ?? this.playerState,
        playbackRate: playbackRate ?? this.playbackRate,
        playbackQuality: playbackQuality ?? this.playbackQuality,
        errorCode: errorCode ?? this.errorCode,
        webViewController: webViewController ?? this.webViewController,
        isDraggingProgressBar:
            isDraggingProgressBar ?? this.isDraggingProgressBar,
        videoMetadata: videoMetadata ?? this.videoMetadata,
      );
}

class YoutubePlayerController extends ValueNotifier<YoutubePlayerValue> {
  /// Creates [YoutubePlayerController].
  YoutubePlayerController(
    this.controlsVisibleAtStart,
    this.autoPlay,
    this.disableDragSeek,
    this.enableCaption,
    this.captionLanguage,
    this.preferHighDefinition,
    this.startAt,
    this.endAt,
    this.useHybridComposition, {
    required this.initialVideoId,
  }) : super(YoutubePlayerValue());

  /// The video id with which the player initializes.
  final String initialVideoId;

  /// Is set to true, controls will be visible at start.
  ///
  /// Default is false.
  final bool controlsVisibleAtStart;

  /// Define whether to auto play the video after initialization or not.
  ///
  /// Default is true.
  final bool autoPlay;

  /// Disables seeking video position when dragging horizontally.
  ///
  /// Default is false.
  final bool disableDragSeek;

  /// Enabling causes closed captions to be shown by default.
  ///
  /// Default is true.
  final bool enableCaption;

  /// Specifies the default language that the player will use to display captions. Set the parameter's value to an [ISO 639-1 two-letter language code](http://www.loc.gov/standards/iso639-2/php/code_list.php).
  ///
  /// Default is `en`.
  final String captionLanguage;

  /// Forces High Definition video quality when possible
  ///
  /// Default is false.
  final bool preferHighDefinition;

  /// Specifies the default starting point of the video in seconds
  ///
  /// Default is 0.
  final int startAt;

  /// Specifies the default end point of the video in seconds
  final int? endAt;

  /// Set to `true` to enable Flutter's new Hybrid Composition. The default value is `true`.
  /// Hybrid Composition is supported starting with Flutter v1.20+.
  ///
  /// **NOTE**: It is recommended to use Hybrid Composition only on Android 10+ for a release app,
  /// as it can cause framerate drops on animations in Android 9 and lower (see [Hybrid-Composition#performance](https://github.com/flutter/flutter/wiki/Hybrid-Composition#performance)).
  final bool useHybridComposition;

  void updateValue({
    bool? isReady,
    bool? isControlsVisible,
    bool? isLoaded,
    bool? hasPlayed,
    Duration? position,
    double? buffered,
    bool? isPlaying,
    bool? isFullScreen,
    int? volume,
    PlayerState? playerState,
    double? playbackRate,
    String? playbackQuality,
    int? errorCode,
    InAppWebViewController? webViewController,
    bool? isDraggingProgressBar,
    VideoMetadata? videoMetadata,
  }) {
    value = value.copyWith(
      isReady: isReady ?? value.isReady,
      isControlsVisible: isControlsVisible ?? value.isControlsVisible,
      hasPlayed: hasPlayed ?? value.hasPlayed,
      position: position ?? value.position,
      buffered: buffered ?? value.buffered,
      isPlaying: isPlaying ?? value.isPlaying,
      isFullScreen: isFullScreen ?? value.isFullScreen,
      volume: volume ?? value.volume,
      playerState: playerState ?? value.playerState,
      playbackRate: playbackRate ?? value.playbackRate,
      playbackQuality: playbackQuality ?? value.playbackQuality,
      errorCode: errorCode ?? value.errorCode,
      webViewController: webViewController ?? value.webViewController,
      isDraggingProgressBar:
          isDraggingProgressBar ?? value.isDraggingProgressBar,
      videoMetadata: videoMetadata ?? value.videoMetadata,
    );
  }

  void _callMethod(String method) {
    if (value.isReady) {
      value.webViewController?.evaluateJavascript(source: method);
    } else {
      log('The controller is not ready for method calls.');
    }
  }

  void play() => _callMethod('play()');

  void pause() => _callMethod('pause()');

  void load(String videoId, {int startAt = 0, int? endAt}) {
    var loadParams = 'videoId:"$videoId",startSeconds:$startAt';
    if (endAt != null && endAt > startAt) {
      loadParams += ',endSeconds:$endAt';
    }
    _updateValues(videoId);
    if (value.errorCode == 1) {
      pause();
    } else {
      _callMethod('loadById({$loadParams})');
    }
  }

  void cue(String videoId, {int startAt = 0, int? endAt}) {
    var cueParams = 'videoId:"$videoId",startSeconds:$startAt';
    if (endAt != null && endAt > startAt) {
      cueParams += ',endSeconds:$endAt';
    }
    _updateValues(videoId);
    if (value.errorCode == 1) {
      pause();
    } else {
      _callMethod('cueById({$cueParams})');
    }
  }

  void _updateValues(String id) {
    if (id.length != 11) {
      updateValue(
        errorCode: 1,
      );
      return;
    }
    updateValue(errorCode: 0, hasPlayed: false);
  }

  void mute() => _callMethod('mute()');

  void unmute() => _callMethod('unMute()');

  void setVolume(int volume) => volume >= 0 && volume <= 100
      ? _callMethod('setVolume($volume)')
      : throw AssertionError('Volume should be between 0 and 100');

  /// Seek to any position. Video auto plays after seeking.
  /// The optional allowSeekAhead parameter determines whether the player will make a new request to the server
  /// if the seconds parameter specifies a time outside of the currently buffered video data.
  /// Default allowSeekAhead = true
  void seekTo(Duration position, {bool allowSeekAhead = true}) {
    _callMethod('seekTo(${position.inMilliseconds / 1000},$allowSeekAhead)');
    play();
    updateValue(position: position);
  }

  void setSize(Size size) =>
      _callMethod('setSize(${size.width}, ${size.height})');

  void fitWidth(Size screenSize) {
    final adjustedHeight = 9 / 16 * screenSize.width;
    setSize(Size(screenSize.width, adjustedHeight));
    _callMethod(
      'setTopMargin("-${((adjustedHeight - screenSize.height) / 2 * 100).abs()}px")',
    );
  }

  /// Fits the video to screen height.
  void fitHeight(Size screenSize) {
    setSize(screenSize);
    _callMethod('setTopMargin("0px")');
  }

  /// Sets the playback speed for the video.
  void setPlaybackRate(double rate) => _callMethod('setPlaybackRate($rate)');

  VideoMetadata get metadata => value.videoMetadata;

  /// The video id will reset to [initialVideoId] after reload.
  void reload() => value.webViewController?.reload();

  /// Resets the value of [YoutubePlayerController].
  void reset() => updateValue(
        isReady: false,
        isFullScreen: false,
        isControlsVisible: false,
        playerState: PlayerState.unloaded,
        hasPlayed: false,
        position: Duration.zero,
        buffered: 0.0,
        errorCode: 0,
        isLoaded: false,
        isPlaying: false,
        isDraggingProgressBar: false,
        videoMetadata: const VideoMetadata(),
      );

  @override
  void dispose() {
    value.webViewController?.dispose();
    super.dispose();
  }
}
