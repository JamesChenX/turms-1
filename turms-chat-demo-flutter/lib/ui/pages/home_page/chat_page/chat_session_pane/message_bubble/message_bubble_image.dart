import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:material_symbols_icons/symbols.dart';
import 'package:path/path.dart';

import '../../../../../../infra/crypto/crypto_utils.dart';
import '../../../../../../infra/http/http_utils.dart';
import '../../../../../../infra/io/path_utils.dart';
import '../../../../../../infra/media/cache_memory_image_provider.dart';
import '../../../../../../infra/task/task_utils.dart';
import '../../../../../../infra/units/file_size_extensions.dart';
import '../../../../../themes/theme_config.dart';

const _imageBorderWidth = 1.0;

class MessageBubbleImage extends StatefulWidget {
  const MessageBubbleImage({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<MessageBubbleImage> createState() => _MessageBubbleImageState();
}

const maxWidth = 200;
const maxHeight = 200;

class _MessageBubbleImageState extends State<MessageBubbleImage> {
  late Image image;

  late Future<Uint8List?> downloadFile;
  late String thumbnailImagePath;

  @override
  void initState() {
    super.initState();

    downloadFile = _getImage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Image(
        isAntiAlias: true,
        gaplessPlayback: true,
        image: CachedMemoryImageProvider(thumbnailImagePath, downloadFile),
        // cacheHeight: maxHeight,
        // cacheWidth: maxWidth,
        // width: maxWidth.toDouble(),
        // height: maxHeight.toDouble(),
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: ThemeConfig.borderRadius4,
                    border: Border.all(
                        color: ThemeConfig.borderDefaultColor,
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
            children: [
              SizedBox(
                width: maxWidth.toDouble(),
                height: maxHeight.toDouble(),
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black12),
                ),
              ),
              const Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildError(),
      );

// todo: click to download
  Stack _buildError() => Stack(
        children: [
          SizedBox(
            width: maxWidth.toDouble(),
            height: maxHeight.toDouble(),
            child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black12),
            ),
          ),
          const Center(
            child: Icon(Symbols.image_not_supported_rounded),
          )
        ],
      );

  Future<Uint8List?> _getImage() async {
    final url = widget.url;
    final urlStr = url.toString();
    final ext = extension(urlStr);
    final fileBaseName = CryptoUtils.getSha256ByString(urlStr);
    final fileName = '$fileBaseName$ext';
    final outputImagePath =
        PathUtils.joinAppPath(['files', '$fileBaseName-thumbnail$ext']);
    thumbnailImagePath = outputImagePath;
    final outputFile = File(outputImagePath);
    if (await outputFile.exists()) {
      // cache result
      return outputFile.readAsBytes();
    }
    final filePath = PathUtils.joinAppPath(['files', fileName]);
    return HttpUtils.downloadFileIfNotExists(
      taskId: filePath,
      uri: Uri.parse(url),
      filePath: filePath,
      maxBytes: 10.MB,
    ).then((value) async {
      if (value == null) {
        return null;
      }
      final bytes = await value.bytes;
      if (bytes.isEmpty) {
        return null;
      }
      return TaskUtils.addTask(
          id: outputImagePath,
          callback: () => compute((message) async {
                var image = img.decodeNamedImage(filePath, bytes);
                if (image == null) {
                  return null;
                }
                if (image.width > maxWidth || image.height > maxHeight) {
                  if (image.width > image.height) {
                    image = img.copyResize(image,
                        width: maxWidth,
                        maintainAspect: true,
                        interpolation: img.Interpolation.cubic);
                  } else {
                    image = img.copyResize(image,
                        height: maxHeight,
                        maintainAspect: true,
                        interpolation: img.Interpolation.cubic);
                  }
                }

                final encodedImageBytes =
                    img.encodeNamedImage(outputImagePath, image);
                if (encodedImageBytes == null) {
                  return null;
                }

                // final outputImage = img.copyResize(image,
                //     width: 200, height: 200, maintainAspect: true, interpolation: img.Interpolation.cubic);
                // final encodedImageBytes =
                //     img.encodeNamedImage(outputImagePath, outputImage);
                // if (encodedImageBytes == null) {
                //   return null;
                // }
                await outputFile.writeAsBytes(encodedImageBytes);
                return encodedImageBytes;
              }, null));
    });
  }
}
