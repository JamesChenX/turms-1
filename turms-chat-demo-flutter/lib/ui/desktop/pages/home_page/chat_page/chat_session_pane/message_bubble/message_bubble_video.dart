import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../../infra/crypto/crypto_utils.dart';
import '../../../../../../../infra/exception/exception_extensions.dart';
import '../../../../../../../infra/exception/user_visible_exception.dart';
import '../../../../../../../infra/http/downloaded_file.dart';
import '../../../../../../../infra/http/file_too_large_exception.dart';
import '../../../../../../../infra/http/http_utils.dart';
import '../../../../../../../infra/io/path_utils.dart';
import '../../../../../../../infra/units/file_size_extensions.dart';
import '../../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../../../themes/theme_config.dart';
import '../../../../../components/index.dart';

const _maxAllowedMb = 100;
final _maxAllowedBytes = _maxAllowedMb.MB;

class MessageBubbleVideo extends ConsumerStatefulWidget {
  const MessageBubbleVideo({Key? key, required this.url}) : super(key: key);

  final Uri url;

  @override
  ConsumerState<MessageBubbleVideo> createState() => _MessageBubbleVideoState();
}

class _MessageBubbleVideoState extends ConsumerState<MessageBubbleVideo> {
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
        final DownloadedFile? downloadedFile;
        try {
          downloadedFile = await HttpUtils.downloadFile(
              taskId: filePath,
              uri: url,
              filePath: filePath,
              maxBytes: _maxAllowedBytes);
        } on FileTooLargeException catch (e) {
          throw UserVisibleException(
              e,
              (cause) => ref
                  .read(appLocalizationsViewModel)
                  .failedToDownloadFileTooLarge(_maxAllowedMb));
        } catch (e) {
          throw UserVisibleException(
              e, (_) => ref.read(appLocalizationsViewModel).failedToDownload);
        }
        if (downloadedFile == null) {
          throw UserVisibleException(
              null, (_) => ref.read(appLocalizationsViewModel).videoNotFound);
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
      // TODO: use video size
      width: 200,
      height: 200,
      child: TAsyncBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) => snapshot.when(
                data: (data) => _buildStack(),
                error: (error, stackTrace) {
                  final message = switch (error) {
                    UserVisibleException(:final message) => message,
                    final Exception e =>
                      '${ref.watch(appLocalizationsViewModel).error}: ${e.message}',
                    _ =>
                      '${ref.watch(appLocalizationsViewModel).error}: $error',
                  };
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: ThemeConfig.maskColor,
                    ),
                    child: Center(
                      child: Row(
                        spacing: 16,
                        children: [
                          const Icon(
                            Symbols.info_i_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          Text(
                            message,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(
                    child: RepaintBoundary(child: CircularProgressIndicator())),
              )));

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
                onTap: () async {
                  if (_isPlaying) {
                    await _controller.pause();
                    _isPlaying = false;
                  } else {
                    await _controller.play();
                    _isPlaying = true;
                  }
                  setState(() {});
                },
              ),
            ),
          )
        ],
      );
}
