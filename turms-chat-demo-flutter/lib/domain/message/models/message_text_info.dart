import 'message_type.dart';

class MessageTextInfo {
  const MessageTextInfo(
      {required this.type, this.thumbnailUrl, this.originalUrl});

  final MessageType type;
  final String? thumbnailUrl;
  final String? originalUrl;

  static const MessageTextInfo text = MessageTextInfo(type: MessageType.text);
}
