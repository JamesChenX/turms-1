import 'message_type.dart';

class MessageInfo {
  const MessageInfo(
      {required this.type,
      this.originalUrl,
      this.originalWidth,
      this.originalHeight});

  final MessageType type;

  // TODO: no turms server support generate thumbnail yet,
  // so there is no point to use thumbnailUrl currently.
  // final String? thumbnailUrl;
  final String? originalUrl;
  final int? originalWidth;
  final int? originalHeight;

  static const MessageInfo text = MessageInfo(type: MessageType.text);
}
