import '../models/message_text_info.dart';
import '../models/message_type.dart';

/// e.g. "![http://example.com/image.png](http://example.com/image.png)"
/// The first group is the required original resource HTTP URL.
/// The second group is the optional thumbnail image HTTP URL.
final _markdownResourceRegex = RegExp(r'!\[(https?:\/\/\S+?\.\S+?)]\((.*?)\)');

class MessageService {
  MessageTextInfo parseMessageInfo(String text) {
    if (!text.startsWith('![')) {
      return MessageTextInfo.text;
    }
    final matches = _markdownResourceRegex.allMatches(text);
    final matchCount = matches.length;
    if (matchCount == 0 || matchCount > 1) {
      return MessageTextInfo.text;
    }
    final match = matches.first;
    if (match.groupCount != 2) {
      return MessageTextInfo.text;
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
      return MessageTextInfo(
        type: MessageType.youtube,
        thumbnailUrl: thumbnailUrl,
        originalUrl: originalUrl,
      );
    } else if (originalUrl.endsWith('.mp4') ||
        originalUrl.endsWith('.mov') ||
        originalUrl.endsWith('.avi')) {
      return MessageTextInfo(
        type: MessageType.video,
        thumbnailUrl: thumbnailUrl,
        originalUrl: originalUrl,
      );
    } else if (originalUrl.endsWith('.mp3') || originalUrl.endsWith('.wav')) {
      return MessageTextInfo(
        type: MessageType.audio,
        thumbnailUrl: thumbnailUrl,
        originalUrl: originalUrl,
      );
    } else if (_isSupportedImageType(originalUrl)) {
      return MessageTextInfo(
        type: MessageType.image,
        thumbnailUrl: thumbnailUrl,
        originalUrl: originalUrl,
      );
    } else {
      return MessageTextInfo(
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
      originalUrl.endsWith('.gif');

  String encodeImageMessage(String originalUrl, String thumbnailUrl) =>
      '![$originalUrl]($thumbnailUrl)';
}

MessageService messageService = MessageService();
