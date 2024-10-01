import 'package:fixnum/fixnum.dart';

import '../../../../../../domain/message/models/message_delivery_status.dart';
import '../../../../../../domain/message/models/message_type.dart';

class ChatMessage {

  const ChatMessage(
      {required this.type,
      required this.messageId,
      required this.senderId,
      required this.sentByMe,
      required this.isFakeMessage,
      required this.isGroupMessage,
      required this.text,
      required this.timestamp,
      required this.status,
      required this.mentionAll,
      required this.mentionedUserIds,
      this.originalUrl,
      this.originalWidth,
      this.originalHeight});

  final MessageType type;
  final Int64 messageId;
  final Int64 senderId;
  final bool sentByMe;
  final bool isFakeMessage;
  final bool isGroupMessage;
  final String text;
  // final List<ChatMessageSpan> spans;
  final DateTime timestamp;
  final MessageDeliveryStatus status;

  final bool mentionAll;
  final Set<Int64> mentionedUserIds;

  final String? originalUrl;
  final int? originalWidth;
  final int? originalHeight;
}

enum ChatMessageSpanType { plain, emoji }

class ChatMessageSpan {
  const ChatMessageSpan({
    required this.type,
    required this.text,
  });

  final ChatMessageSpanType type;
  final String text;
}