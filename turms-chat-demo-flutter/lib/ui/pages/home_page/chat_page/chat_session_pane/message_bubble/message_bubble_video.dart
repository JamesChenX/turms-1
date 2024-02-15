import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:video_player/video_player.dart';

class MessageBubbleVideo extends StatefulWidget {
  const MessageBubbleVideo({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<MessageBubbleVideo> createState() => _MessageBubbleVideoState();
}

class _MessageBubbleVideoState extends State<MessageBubbleVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller
      ..setVolume(1.0)
      ..addListener(() {
        if (_controller.value.position == _controller.value.duration) {
          _controller.seekTo(Duration.zero);
          _isPlaying = false;
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 200,
        height: 200,
        child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    if (!_isPlaying)
                      Center(
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(128, 0, 0, 0),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white),
                            ),
                            child: const Center(
                              child: Icon(
                                Symbols.play_arrow_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Positioned.fill(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            if (_isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                            _isPlaying = !_isPlaying;
                            setState(() {});
                          },
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      );
}