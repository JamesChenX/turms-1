import 'package:fixnum/fixnum.dart';

import '../../../../../domain/message/message_delivery_status.dart';

class ChatMessage {
  const ChatMessage(this.senderId, this.sentByMe, this.text,
      this.timestamp, this.status);

  final Int64 senderId;
  final bool sentByMe;
  final String text;
  final DateTime timestamp;
  final MessageDeliveryStatus status;
}