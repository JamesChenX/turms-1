import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';

import '../../../../../../infra/crypto/crypto_utils.dart';
import '../../../../../../infra/env/env_vars.dart';
import '../../../../../../infra/http/http_utils.dart';
import '../../../../../../infra/http/resource_not_found_exception.dart';
import '../../../../../../infra/io/path_utils.dart';
import '../../../../../../infra/media/corrupted_media_file_exception.dart';
import '../../../../../../infra/task/task_utils.dart';
import '../../../../../../infra/units/file_size_extensions.dart';
import '../../../../../../infra/worker/worker_manager.dart';
import '../message_media_file.dart';

class MessageImageProvider extends ImageProvider<MessageImageProvider> {
  MessageImageProvider(this.originalImageUrl, this.asThumbnail);

  final String originalImageUrl;
  final bool asThumbnail;
  final StreamController<ImageChunkEvent> chunkEvents =
      StreamController<ImageChunkEvent>();
  MessageMediaFile? mediaFile;

  @override
  Future<MessageImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<MessageImageProvider>(this);

  @override
  ImageStreamCompleter loadImage(
          MessageImageProvider key, ImageDecoderCallback decode) =>
      MultiFrameImageStreamCompleter(
        codec: _load(decode),
        scale: 1.0,
        debugLabel: '$originalImageUrl:$asThumbnail',
        chunkEvents: chunkEvents.stream,
        informationCollector: () sync* {
          yield ErrorDescription(
              'Cache Entry ID: $originalImageUrl:$asThumbnail');
        },
      );

  Future<Codec> _load(ImageDecoderCallback decode) async {
    final bytes = await _fetchImage();
    final buffer = await ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }

  Future<Uint8List> _fetchImage() async {
    // 1. Prepare the paths.
    final url = originalImageUrl;
    final urlStr = url.toString();
    final ext = extension(urlStr);
    final fileBaseName = CryptoUtils.getSha256ByString(urlStr);
    final fileFullName = '$fileBaseName$ext';
    final outputOriginalImagePath =
        PathUtils.joinPathInUserScope(['files', fileFullName]);
    final outputThumbnailPath =
        PathUtils.joinPathInUserScope(['files', '$fileBaseName-thumbnail$ext']);
    if (asThumbnail) {
      final outputThumbnailFile = File(outputThumbnailPath);
      if (await outputThumbnailFile.exists()) {
        return outputThumbnailFile.readAsBytes();
      }
      chunkEvents.add(const ImageChunkEvent(
          cumulativeBytesLoaded: 0, expectedTotalBytes: null));
      final mediaFile = await TaskUtils.cacheFutureProvider(
          id: 'download:$url',
          futureProvider: () => WorkerManager.schedule(_fetchImage0,
              [url, outputOriginalImagePath, outputThumbnailPath]));
      return mediaFile.thumbnailBytes ?? mediaFile.originalMediaBytes!;
    } else {
      final outputOriginalImageFile = File(outputOriginalImagePath);
      if (await outputOriginalImageFile.exists()) {
        return outputOriginalImageFile.readAsBytes();
      }
      chunkEvents.add(const ImageChunkEvent(
          cumulativeBytesLoaded: 0, expectedTotalBytes: null));
      final mediaFile = await TaskUtils.cacheFutureProvider(
          id: 'download:$url',
          futureProvider: () => WorkerManager.schedule(_fetchImage0,
              [url, outputOriginalImagePath, outputThumbnailPath]));
      return mediaFile.originalMediaBytes!;
    }
  }

  Future<MessageMediaFile> _fetchImage0(List<dynamic> args) async {
    final uri = args[0] as String;
    final outputOriginalImagePath = args[1] as String;
    final outputThumbnailPath = args[2] as String;
    final originalImageFile = await HttpUtils.downloadFile(
      uri: Uri.parse(uri),
      filePath: outputOriginalImagePath,
      maxBytes: EnvVars.messageImageMaxDownloadableSizeBytes.MB,
    );
    if (originalImageFile == null) {
      throw ResourceNotFoundException(uri);
    }
    final originalImageBytes = await originalImageFile.bytes;
    if (originalImageBytes.isEmpty) {
      throw ResourceNotFoundException(uri);
    }
    // Don't resize GIF images because the "image" package
    // is buggy for resizing GIF images.
    // e.g. https://github.com/brendan-duncan/image/issues/588
    // TODO: waiting for them to be fixed.
    if (outputOriginalImagePath.endsWith('.gif')) {
      return MessageMediaFile(
        originalMediaUrl: uri,
        originalMediaPath: outputOriginalImagePath,
        originalMediaBytes: originalImageBytes,
      );
    }
    var originalImage =
        img.decodeNamedImage(outputOriginalImagePath, originalImageBytes);
    if (originalImage == null) {
      throw const CorruptedMediaFileException();
    }
    if (originalImage.width > EnvVars.messageImageThumbnailSizeWidth ||
        originalImage.height > EnvVars.messageImageThumbnailSizeHeight) {
      originalImage = originalImage.convert(numChannels: 4);
      final thumbnail = img.copyResize(originalImage,
          width: originalImage.width > originalImage.height
              ? EnvVars.messageImageThumbnailSizeWidth
              : EnvVars.messageImageThumbnailSizeHeight,
          maintainAspect: true,
          interpolation: img.Interpolation.cubic);
      final thumbnailBytes =
          img.encodeNamedImage(outputThumbnailPath, thumbnail)!;
      await File(outputThumbnailPath).writeAsBytes(thumbnailBytes);
      return MessageMediaFile(
        originalMediaUrl: uri,
        originalMediaPath: outputOriginalImagePath,
        originalMediaBytes: originalImageBytes,
        thumbnailPath: outputThumbnailPath,
        thumbnailBytes: thumbnailBytes,
      );
    }
    return MessageMediaFile(
      originalMediaUrl: uri,
      originalMediaPath: outputOriginalImagePath,
      originalMediaBytes: originalImageBytes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MessageImageProvider &&
        other.originalImageUrl == originalImageUrl &&
        other.asThumbnail == asThumbnail;
  }

  @override
  int get hashCode => originalImageUrl.hashCode ^ asThumbnail.hashCode;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'MessageImageProvider')}("$originalImageUrl:$asThumbnail")';
}