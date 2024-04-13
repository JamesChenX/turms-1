import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';

import '../../../../../../infra/crypto/crypto_utils.dart';
import '../../../../../../infra/env/env_vars.dart';
import '../../../../../../infra/http/http_utils.dart';
import '../../../../../../infra/io/path_utils.dart';
import '../../../../../../infra/media/future_memory_image_provider.dart';
import '../../../../../../infra/task/task_utils.dart';
import '../../../../../../infra/units/file_size_extensions.dart';
import '../../../../../../infra/worker/worker_manager.dart';
import '../../../../../components/t_image/t_image_broken.dart';
import '../../../../../components/t_image_viewer/t_image_viewer.dart';
import '../../../../../themes/theme_config.dart';
import '../media_fetching_status.dart';
import '../message_media_file.dart';

const _imageBorderWidth = 1.0;

class MessageBubbleImage extends StatefulWidget {
  const MessageBubbleImage({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<MessageBubbleImage> createState() => _MessageBubbleImageState();
}

class _MessageBubbleImageState extends State<MessageBubbleImage> {
  late Image image;

  late Future<(Uint8List, bool)?> downloadFile;
  late String originalImagePath;
  late String thumbnailImagePath;

  @override
  void initState() {
    super.initState();

    unawaited(_initImage());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () async {
            final originalImageFile = File(originalImagePath);
            final ImageProvider image;
            if (await originalImageFile.exists()) {
              image = FileImage(originalImageFile);
            } else {
              // TODO: show a tip to let user know if the original image has been deleted.
              // image =
              //     FutureMemoryImageProvider(thumbnailImagePath, downloadFile);
              image = MemoryImage((await downloadFile)!);
            }
            unawaited(showImageViewerDialog(context, image));
          },
          child: _buildThumbnailImage()));

  Image _buildThumbnailImage() => Image(
        isAntiAlias: true,
        gaplessPlayback: true,
        image: FutureMemoryImageProvider(thumbnailImagePath, downloadFile),
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: ThemeConfig.borderRadius4,
                    border: Border.all(
                        color: ThemeConfig.borderColor,
                        width: _imageBorderWidth)),
                child: ClipRRect(
                  borderRadius: ThemeConfig.borderRadius4,
                  child: Padding(
                    padding: const EdgeInsets.all(_imageBorderWidth),
                    child: child,
                  ),
                ));
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              SizedBox(
                width: EnvVars.messageImageThumbnailSizeWidth.toDouble(),
                height: EnvVars.messageImageThumbnailSizeHeight.toDouble(),
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black12),
                ),
              ),
              const Center(
                child: RepaintBoundary(child: CupertinoActivityIndicator()),
              )
            ],
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildError(),
      );

// todo: click to download
  // handle different cases
  Widget _buildError() => const TImageBroken();

  // Stack _buildError() => Stack(
  //       children: [
  //         SizedBox(
  //           width: EnvVars.messageImageThumbnailSizeWidth.toDouble(),
  //           height: EnvVars.messageImageThumbnailSizeWidth.toDouble(),
  //           child: const DecoratedBox(
  //             decoration: BoxDecoration(color: Colors.black12),
  //           ),
  //         ),
  //         const Center(
  //           child: Icon(Symbols.image_not_supported_rounded),
  //         )
  //       ],
  //     );

  Future<void> _initImage() async {
    final url = widget.url;
    final urlStr = url.toString();
    final ext = extension(urlStr);
    final fileBaseName = CryptoUtils.getSha256ByString(urlStr);
    final fileName = '$fileBaseName$ext';
    final outputOriginalImagePath =
        PathUtils.joinPathInUserScope(['files', fileName]);
    originalImagePath = outputOriginalImagePath;
    final outputThumbnailImagePath =
        PathUtils.joinPathInUserScope(['files', '$fileBaseName-thumbnail$ext']);
    thumbnailImagePath = outputThumbnailImagePath;
    final outputThumbnailImageFile = File(outputThumbnailImagePath);
    if (await outputThumbnailImageFile.exists()) {
      final bytes = await outputThumbnailImageFile.readAsBytes();
      downloadFile = Future.value((bytes, true));
    } else {
      downloadFile = TaskUtils.cacheFuture(
        id: outputThumbnailImagePath,
        future: WorkerManager.schedule(_fetchImage0,
            [url, outputOriginalImagePath, outputThumbnailImagePath]),
      );
    }
  }
}

Future<(MessageMediaFile, MediaFetchingStatus)> _fetchImage0(
    List<dynamic> args) async {
  final outputOriginalImagePath = args[1] as String;
  final outputThumbnailImagePath = args[2] as String;
  final originalImageFile = await HttpUtils.downloadFileIfNotExists(
    uri: Uri.parse(args[0] as String),
    filePath: outputOriginalImagePath,
    maxBytes: EnvVars.messageImageMaxDownloadableSizeBytes.MB,
  );
  if (originalImageFile == null) {
    return null;
  }
  final originalImageBytes = await originalImageFile.bytes;
  if (originalImageBytes.isEmpty) {
    return null;
  }
  // Don't resize GIF images because the "image" package
  // is buggy for resizing GIF images.
  // e.g. https://github.com/brendan-duncan/image/issues/588
  // TODO: waiting for them to be fixed.
  if (outputOriginalImagePath.endsWith('.gif')) {
    return (originalImageBytes, false);
  }
  var originalImage =
      img.decodeNamedImage(outputOriginalImagePath, originalImageBytes);
  if (originalImage == null) {
    return null;
  }
  if (originalImage.width > EnvVars.messageImageThumbnailSizeWidth ||
      originalImage.height > EnvVars.messageImageThumbnailSizeHeight) {
    final img.Image thumbnailImage;
    originalImage = originalImage.convert(numChannels: 4);
    if (originalImage.width > originalImage.height) {
      thumbnailImage = img.copyResize(originalImage,
          width: EnvVars.messageImageThumbnailSizeWidth,
          maintainAspect: true,
          interpolation: img.Interpolation.cubic);
    } else {
      thumbnailImage = img.copyResize(originalImage,
          height: EnvVars.messageImageThumbnailSizeHeight,
          maintainAspect: true,
          interpolation: img.Interpolation.cubic);
    }
    final encodedImageBytes =
        img.encodeNamedImage(outputThumbnailImagePath, thumbnailImage);
    if (encodedImageBytes == null) {
      return (originalImageBytes, false);
    }
    await File(outputThumbnailImagePath).writeAsBytes(encodedImageBytes);
    return (encodedImageBytes, true);
  }
  return (originalImageBytes, false);
}
