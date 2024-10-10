import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';

class User {
  User(
      {required this.userId,
      required this.name,
      this.intro = '',
      this.imageUrl,
      this.imageBytes});

  final Int64 userId;
  final String name;
  final String intro;
  final String? imageUrl;
  final Uint8List? imageBytes;

  ImageProvider? _cachedImage;

  ImageProvider? get image {
    if (_cachedImage != null) {
      return _cachedImage;
    }
    if (imageBytes case final Uint8List imageBytes) {
      return _cachedImage = MemoryImage(imageBytes);
    }
    if (imageUrl case final String imageUrl) {
      return _cachedImage = NetworkImage(imageUrl);
    }
    return null;
  }
}
