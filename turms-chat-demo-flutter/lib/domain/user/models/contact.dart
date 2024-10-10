import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import 'group_member.dart';
import 'user.dart';

part 'group_contact.dart';

part 'system_contact.dart';

part 'user_contact.dart';

sealed class Contact {
  Contact({
    required this.name,
    this.intro = '',
    this.imageUrl,
    this.imageBytes,
    this.icon,
  });

  final String name;
  final String intro;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final IconData? icon;

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

  String get id;
}
