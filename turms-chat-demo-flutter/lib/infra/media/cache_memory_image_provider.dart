import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CachedMemoryImageProvider
    extends ImageProvider<CachedMemoryImageProvider> {
  CachedMemoryImageProvider(this.cacheEntryId, this.imageBytes);

  final String cacheEntryId;
  final Future<Uint8List?> imageBytes;

  @override
  ImageStreamCompleter loadImage(
          CachedMemoryImageProvider key, ImageDecoderCallback decode) =>
      MultiFrameImageStreamCompleter(
        codec: _loadAsync(decode),
        scale: 1.0,
        debugLabel: cacheEntryId,
        informationCollector: () sync* {
          yield ErrorDescription('Cache Entry ID: $cacheEntryId');
        },
      );

  Future<Codec> _loadAsync(ImageDecoderCallback decode) async {
    final bytes = await imageBytes;
    if (bytes == null || bytes.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance.imageCache.evict(this);
      throw StateError(
          '$cacheEntryId is empty and cannot be loaded as an image');
    }
    final buffer = await ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }

  @override
  Future<CachedMemoryImageProvider> obtainKey(
          ImageConfiguration configuration) =>
      SynchronousFuture<CachedMemoryImageProvider>(this);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CachedMemoryImageProvider &&
        other.cacheEntryId == cacheEntryId;
  }

  @override
  int get hashCode => cacheEntryId.hashCode;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'CacheImageProvider')}("$cacheEntryId")';
}
