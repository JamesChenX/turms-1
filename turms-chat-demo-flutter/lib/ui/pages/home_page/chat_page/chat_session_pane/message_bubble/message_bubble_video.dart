import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../infra/crypto/crypto_utils.dart';
import '../../../../../../infra/http/http_utils.dart';
import '../../../../../../infra/io/path_utils.dart';

class MessageBubbleVideo extends StatefulWidget {
  const MessageBubbleVideo({Key? key, required this.url}) : super(key: key);

  final Uri url;

  @override
  State<MessageBubbleVideo> createState() => _MessageBubbleVideoState();
}

class _MessageBubbleVideoState extends State<MessageBubbleVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool _isPlaying = false;

  @override
  void didUpdateWidget(MessageBubbleVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();

    _initializeVideoPlayerFuture = Future.microtask(() async {
      final url = widget.url;
      final urlStr = url.toString();
      final ext = extension(urlStr);
      final fileName = '${CryptoUtils.getSha256ByString(urlStr)}.$ext';
      final filePath = PathUtils.joinPathInUserScope(['files', fileName]);
      final file = File(filePath);
      final VideoPlayerController controller;
      if (await file.exists()) {
        controller = VideoPlayerController.file(File(filePath));
      } else {
        final downloadedFile = await HttpUtils.downloadFile(
            taskId: filePath, uri: url, filePath: filePath);
        if (downloadedFile == null) {
          // TODO: display illegal file
          return;
        }
        controller = VideoPlayerController.file(downloadedFile.file);
      }
      await controller.setVolume(1.0);
      controller.addListener(() {
        if (controller.value.position == controller.value.duration) {
          controller.seekTo(Duration.zero);
          _isPlaying = false;
          setState(() {});
        }
      });
      await controller.initialize();
      _controller = controller;
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
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.done
                ? _buildStack()
                : const Center(
                    child:
                        RepaintBoundary(child: CircularProgressIndicator()))),
      );

  Widget _buildStack() => Stack(
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
}
