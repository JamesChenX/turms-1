import 'dart:convert';

import '../models/message_text_info.dart';
import '../models/message_type.dart';

/// e.g.:
/// 1. "![an example|100x100](http://example.com/image.png)"
/// 2. "![an example|100x100](http://example.com/video.mp4)"
/// 3. "[![an example|100x100](http://example.com/image.png)](http://example.com/video.mp4)"
/// The first group is the required original resource HTTP URL.
/// The second group is the optional thumbnail image HTTP URL.
final _markdownResourceRegex = RegExp(r'!\[(https?:\/\/\S+?\.\S+?)]\((.*?)\)');

class MessageService {
  MessageInfo parseMessageInfo(String text) {
    if (!text.startsWith('![')) {
      return MessageInfo.text;
    }
    final matches = _markdownResourceRegex.allMatches(text);
    final matchCount = matches.length;
    if (matchCount == 0 || matchCount > 1) {
      return MessageInfo.text;
    }
    final match = matches.first;
    if (match.groupCount != 2) {
      return MessageInfo.text;
    }
    String? thumbnailUrl = match.group(2)!;
    if (!thumbnailUrl.startsWith('http://') &&
        !thumbnailUrl.startsWith('https://') &&
        !_isSupportedImageType(thumbnailUrl)) {
      thumbnailUrl = null;
    }
    final originalUrl = match.group(1)!;
    if (originalUrl.contains('//www.youtube.com/') ||
        originalUrl.contains('//youtube.com/')) {
      return MessageInfo(
        type: MessageType.youtube,
        thumbnailUrl: thumbnailUrl,
        originalUrl: originalUrl,
      );
    } else if (originalUrl.endsWith('.mp4') ||
        originalUrl.endsWith('.mov') ||
        originalUrl.endsWith('.avi')) {
      return MessageInfo(
        type: MessageType.video,
        thumbnailUrl: thumbnailUrl,
        originalUrl: originalUrl,
      );
    } else if (originalUrl.endsWith('.mp3') || originalUrl.endsWith('.wav')) {
      return MessageInfo(
        type: MessageType.audio,
        thumbnailUrl: thumbnailUrl,
        originalUrl: originalUrl,
      );
    } else if (_isSupportedImageType(originalUrl)) {
      return MessageInfo(
        type: MessageType.image,
        thumbnailUrl: thumbnailUrl,
        originalUrl: originalUrl,
      );
    } else {
      return MessageInfo(
        type: MessageType.file,
        thumbnailUrl: thumbnailUrl,
        originalUrl: originalUrl,
      );
    }
  }

  bool _isSupportedImageType(String originalUrl) =>
      originalUrl.endsWith('.png') ||
      originalUrl.endsWith('.jpg') ||
      originalUrl.endsWith('.jpeg') ||
      originalUrl.endsWith('.gif') ||
      originalUrl.endsWith('.webp');

  String encodeImageMessage(String originalUrl, String thumbnailUrl) =>
      '![$originalUrl]($thumbnailUrl)';
}

MessageService messageService = MessageService();
