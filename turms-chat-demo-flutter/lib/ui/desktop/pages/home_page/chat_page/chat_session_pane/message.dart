import 'package:fixnum/fixnum.dart';

import '../../../../../../domain/message/models/message_delivery_status.dart';
import '../../../../../../domain/message/models/message_type.dart';
import '../../../../../../domain/message/services/message_service.dart';

class ChatMessage {
  factory ChatMessage.parse(
    String text, {
    required Int64 messageId,
    required Int64 senderId,
    required bool sentByMe,
    required bool isFakeMessage,
    required bool isGroupMessage,
    required DateTime timestamp,
    required MessageDeliveryStatus status,
  }) {
    final info = messageService.parseMessageInfo(text);
    return ChatMessage(
      type: info.type,
      messageId: messageId,
      text: text,
      senderId: senderId,
      sentByMe: sentByMe,
      isFakeMessage: isFakeMessage,
      isGroupMessage: isGroupMessage,
      timestamp: timestamp,
      status: status,
      originalUrl: info.originalUrl,
      originalWidth: info.originalWidth,
      originalHeight: info.originalHeight,
      mentionAll: info.mentionAll ?? false,
      mentionedUserIds: info.mentionedUserIds ?? const {},
    );
  }

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
  final double? originalWidth;
  final double? originalHeight;

  ChatMessage copyWith({
    MessageType? type,
    Int64? messageId,
    Int64? senderId,
    bool? sentByMe,
    bool? isFakeMessage,
    bool? isGroupMessage,
    String? text,
    DateTime? timestamp,
    MessageDeliveryStatus? status,
    bool? mentionAll,
    Set<Int64>? mentionedUserIds,
    String? originalUrl,
    double? originalWidth,
    double? originalHeight,
  }) =>
      ChatMessage(
        type: type ?? this.type,
        messageId: messageId ?? this.messageId,
        senderId: senderId ?? this.senderId,
        sentByMe: sentByMe ?? this.sentByMe,
        isFakeMessage: isFakeMessage ?? this.isFakeMessage,
        isGroupMessage: isGroupMessage ?? this.isGroupMessage,
        text: text ?? this.text,
        timestamp: timestamp ?? this.timestamp,
        status: status ?? this.status,
        mentionAll: mentionAll ?? this.mentionAll,
        mentionedUserIds: mentionedUserIds ?? this.mentionedUserIds,
        originalUrl: originalUrl ?? this.originalUrl,
        originalWidth: originalWidth ?? this.originalWidth,
        originalHeight: originalHeight ?? this.originalHeight,
      );
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
