import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'player_state.dart';
import 'video_metadata.dart';
import 'youtube_player_controller.dart';

class RawYoutubePlayer extends StatefulWidget {
  const RawYoutubePlayer({
    super.key,
    required this.controller,
    required this.onEnded,
  });

  final YoutubePlayerController controller;
  final void Function() onEnded;

  @override
  State<RawYoutubePlayer> createState() => _RawYoutubePlayerState();
}

class _RawYoutubePlayerState extends State<RawYoutubePlayer> {
  bool _isPlayerReady = false;
  bool _onLoadStopCalled = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return IgnorePointer(
      child: InAppWebView(
        key: widget.key,
        initialData: InAppWebViewInitialData(
          data: player,
          baseUrl: WebUri.uri(Uri.https('www.youtube.com')),
          encoding: 'utf-8',
        ),
        initialSettings: InAppWebViewSettings(
          userAgent: userAgent,
          mediaPlaybackRequiresUserGesture: false,
          transparentBackground: true,
          disableContextMenu: true,
          supportZoom: false,
          allowsInlineMediaPlayback: true,
          useWideViewPort: false,
          useHybridComposition: controller.useHybridComposition,
        ),
        onWebViewCreated: (webViewController) {
          controller.value =
              controller.value.copyWith(webViewController: webViewController);
          webViewController
            ..addJavaScriptHandler(
              handlerName: 'Ready',
              callback: (_) {
                _isPlayerReady = true;
                if (_onLoadStopCalled) {
                  controller.updateValue(isReady: true);
                }
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'StateChange',
              callback: (args) {
                final playerState = PlayerState.fromValue(args.first as int);
                if (playerState == null) {
                  return;
                }
                switch (playerState) {
                  case PlayerState.unstarted:
                    controller.updateValue(
                      playerState: playerState,
                      isLoaded: true,
                    );
                    break;
                  case 0:
                    widget.onEnded.call();
                    controller.updateValue(
                      playerState: PlayerState.ended,
                    );
                    break;
                  case 1:
                    controller.updateValue(
                      playerState: PlayerState.playing,
                      isPlaying: true,
                      hasPlayed: true,
                      errorCode: 0,
                    );
                    break;
                  case 2:
                    controller.updateValue(
                      playerState: PlayerState.paused,
                      isPlaying: false,
                    );
                    break;
                  case 3:
                    controller.updateValue(
                      playerState: PlayerState.buffering,
                    );
                    break;
                  case 5:
                    controller.updateValue(
                      playerState: PlayerState.cued,
                    );
                    break;
                  default:
                    throw Exception('Invalid player state obtained');
                }
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'PlaybackQualityChange',
              callback: (args) {
                controller.updateValue(playbackQuality: args.first as String);
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'PlaybackRateChange',
              callback: (args) {
                final rate = args.first as num;
                controller.updateValue(playbackRate: rate.toDouble());
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'Errors',
              callback: (args) {
                controller.updateValue(
                    errorCode: int.parse(args.first as String));
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'VideoData',
              callback: (args) {
                controller.updateValue(
                    videoMetadata: VideoMetadata.fromRawData(args.first));
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'VideoTime',
              callback: (args) {
                final position = (args.first as num) * 1000;
                final buffered = args.last as num;
                controller.updateValue(
                  position: Duration(milliseconds: position.floor()),
                  buffered: buffered.toDouble(),
                );
              },
            );
        },
        onLoadStop: (_, __) {
          _onLoadStopCalled = true;
          if (_isPlayerReady) {
            controller.updateValue(isReady: true);
          }
        },
      ),
    );
  }

  String get player {
    final controller = widget.controller;
    // language=html
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            html,
            body {
                margin: 0;
                padding: 0;
                background-color: #000000;
                overflow: hidden;
                position: fixed;
                height: 100%;
                width: 100%;
                pointer-events: none;
            }
        </style>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
    </head>
    <body>
        <div id="player"></div>
        <script>
            const tag = document.createElement('script');
            tag.src = "https://www.youtube.com/iframe_api";
            const firstScriptTag = document.getElementsByTagName('script')[0];
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
            let player;
            let timerId;
            function onYouTubeIframeAPIReady() {
                player = new YT.Player('player', {
                    height: '100%',
                    width: '100%',
                    videoId: '${controller.initialVideoId}',
                    playerVars: {
                        'controls': 0,
                        'playsinline': 1,
                        'enablejsapi': 1,
                        'fs': 0,
                        'rel': 0,
                        'showinfo': 0,
                        'iv_load_policy': 3,
                        'modestbranding': 1,
                        'cc_load_policy': ${boolean(value: controller.enableCaption)},
                        'cc_lang_pref': '${controller.captionLanguage}',
                        'autoplay': ${boolean(value: controller.autoPlay)},
                        'start': ${controller.startAt},
                        'end': ${controller.endAt}
                    },
                    events: {
                        onReady: function(event) { window.flutter_inappwebview.callHandler('Ready'); },
                        onStateChange: function(event) { sendPlayerStateChange(event.data); },
                        onPlaybackQualityChange: function(event) { window.flutter_inappwebview.callHandler('PlaybackQualityChange', event.data); },
                        onPlaybackRateChange: function(event) { window.flutter_inappwebview.callHandler('PlaybackRateChange', event.data); },
                        onError: function(error) { window.flutter_inappwebview.callHandler('Errors', error.data); }
                    },
                });
            }

            function sendPlayerStateChange(playerState) {
                clearTimeout(timerId);
                window.flutter_inappwebview.callHandler('StateChange', playerState);
                if (playerState == 1) {
                    startSendCurrentTimeInterval();
                    sendVideoData(player);
                }
            }

            function sendVideoData(player) {
                var videoData = {
                    'duration': player.getDuration(),
                    'title': player.getVideoData().title,
                    'author': player.getVideoData().author,
                    'videoId': player.getVideoData().video_id
                };
                window.flutter_inappwebview.callHandler('VideoData', videoData);
            }

            function startSendCurrentTimeInterval() {
                timerId = setInterval(function () {
                    window.flutter_inappwebview.callHandler('VideoTime', player.getCurrentTime(), player.getVideoLoadedFraction());
                }, 100);
            }

            function play() {
                player.playVideo();
                return '';
            }

            function pause() {
                player.pauseVideo();
                return '';
            }

            function loadById(loadSettings) {
                player.loadVideoById(loadSettings);
                return '';
            }

            function cueById(cueSettings) {
                player.cueVideoById(cueSettings);
                return '';
            }

            function loadPlaylist(playlist, index, startAt) {
                player.loadPlaylist(playlist, 'playlist', index, startAt);
                return '';
            }

            function cuePlaylist(playlist, index, startAt) {
                player.cuePlaylist(playlist, 'playlist', index, startAt);
                return '';
            }

            function mute() {
                player.mute();
                return '';
            }

            function unMute() {
                player.unMute();
                return '';
            }

            function setVolume(volume) {
                player.setVolume(volume);
                return '';
            }

            function seekTo(position, seekAhead) {
                player.seekTo(position, seekAhead);
                return '';
            }

            function setSize(width, height) {
                player.setSize(width, height);
                return '';
            }

            function setPlaybackRate(rate) {
                player.setPlaybackRate(rate);
                return '';
            }

            function setTopMargin(margin) {
                document.getElementById("player").style.marginTop = margin;
                return '';
            }
        </script>
    </body>
    </html>
  ''';
  }

  String boolean({required bool value}) => value == true ? "'1'" : "'0'";

  String get userAgent => widget.controller.preferHighDefinition
      ? 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36'
      : '';
}
