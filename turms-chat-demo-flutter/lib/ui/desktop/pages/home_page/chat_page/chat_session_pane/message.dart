import 'package:fixnum/fixnum.dart';

import '../../../../../../domain/message/models/message_delivery_status.dart';

class ChatMessage {
  const ChatMessage(
      {required this.messageId,
      required this.senderId,
      required this.sentByMe,
      required this.text,
      required this.timestamp,
      required this.status});

  final Int64 messageId;
  final Int64 senderId;
  final bool sentByMe;
  final String text;
  final DateTime timestamp;
  final MessageDeliveryStatus status;
}
