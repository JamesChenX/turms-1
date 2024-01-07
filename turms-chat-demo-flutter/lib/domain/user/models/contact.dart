import 'dart:typed_data';

import 'package:flutter/material.dart';

abstract class Contact {
  Contact({
    required this.name,
    this.intro = '',
    this.imageUrl,
    this.imageBytes,
  });

  final String name;
  final String intro;
  final String? imageUrl;
  final Uint8List? imageBytes;

  ImageProvider? _cachedImage;

  ImageProvider? get image {
    if (_cachedImage != null) {
      return _cachedImage;
    }
    if (imageBytes != null) {
      return _cachedImage = MemoryImage(imageBytes!);
    }
    if (imageUrl != null) {
      return _cachedImage = NetworkImage(imageUrl!);
    }
    return null;
  }

  String get id;
}