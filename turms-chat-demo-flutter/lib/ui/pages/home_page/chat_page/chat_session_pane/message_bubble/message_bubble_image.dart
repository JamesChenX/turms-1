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
import '../../../../../../infra/media/future_memory_image_provider.dart';
import '../../../../../../infra/task/task_utils.dart';
import '../../../../../../infra/units/file_size_extensions.dart';
import '../../../../../components/t_image_viewer.dart';
import '../../../../../themes/theme_config.dart';

const _imageBorderWidth = 1.0;

class MessageBubbleImage extends StatefulWidget {
  const MessageBubbleImage({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<MessageBubbleImage> createState() => _MessageBubbleImageState();
}

const maxWidth = 200.0;
const maxHeight = 200.0;

class _MessageBubbleImageState extends State<MessageBubbleImage> {
  late Image image;

  late Future<Uint8List?> downloadFile;
  late String originalImagePath;
  late String thumbnailImagePath;

  @override
  void initState() {
    super.initState();

    downloadFile = _fetchImage();
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
              image =
                  FutureMemoryImageProvider(thumbnailImagePath, downloadFile);
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
          return const Stack(
            fit: StackFit.expand,
            children: [
              SizedBox(
                width: maxWidth,
                height: maxHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black12),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildError(),
      );

// todo: click to download
  Stack _buildError() => const Stack(
        children: [
          SizedBox(
            width: maxWidth,
            height: maxHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black12),
            ),
          ),
          Center(
            child: Icon(Symbols.image_not_supported_rounded),
          )
        ],
      );

  Future<Uint8List?> _fetchImage() async {
    final url = widget.url;
    final urlStr = url.toString();
    final ext = extension(urlStr);
    final fileBaseName = CryptoUtils.getSha256ByString(urlStr);
    final fileName = '$fileBaseName$ext';
    final filePath = PathUtils.joinAppPath(['files', fileName]);
    originalImagePath = filePath;
    final outputImagePath =
        PathUtils.joinAppPath(['files', '$fileBaseName-thumbnail$ext']);
    thumbnailImagePath = outputImagePath;
    final outputFile = File(outputImagePath);
    if (await outputFile.exists()) {
      // cache result
      return outputFile.readAsBytes();
    }
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
                        width: maxWidth.toInt(),
                        maintainAspect: true,
                        interpolation: img.Interpolation.cubic);
                  } else {
                    image = img.copyResize(image,
                        height: maxHeight.toInt(),
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
