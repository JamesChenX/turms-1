import 'dart:math';

import 'package:fixnum/fixnum.dart';

import '../domain/conversation/models/group_conversation.dart';
import '../domain/conversation/models/private_conversation.dart';
import '../domain/message/message_delivery_status.dart';
import '../domain/user/models/group_contact.dart';
import '../domain/user/models/user_contact.dart';
import '../infra/random/random_utils.dart';
import '../ui/pages/home_page/chat_page/chat_session_pane/message.dart';
import 'contacts.dart';

final random = Random(123456789);
final endDate = DateTime(2000, 2, 20);

const _deliveryStatuses = MessageDeliveryStatus.values;

final fixtureConversations = fixtureContacts.map((contact) {
  if (contact is UserContact) {
    final timestamps = <DateTime>[];
    final messages = contactToMessages[contact.userId]!;
    final count = messages.length;
    var date = endDate;
    for (var i = 0; i < count; i++) {
      date = date.add(Duration(seconds: random.nextInt(60 * 60 * 24 * 500)));
      timestamps.add(date);
    }
    return PrivateConversation(
        contact: contact,
        unreadMessageCount:
            messages.isEmpty ? 0 : random.nextInt(messages.length),
        messages: messages.indexed.map((item) {
          final (messageIndex, message) = item;
          final sentByMe = random.nextBool();
          return ChatMessage(
              messageId: RandomUtils.nextUniqueInt64(),
              senderId: sentByMe
                  ?
                  // TODO: We should use the logged in user ID
                  Int64(-1)
                  : contact.userId,
              sentByMe: sentByMe,
              text: message,
              timestamp: timestamps[count - messageIndex - 1],
              status: sentByMe
                  ? _deliveryStatuses[random.nextInt(_deliveryStatuses.length)]
                  : MessageDeliveryStatus.delivered);
        }).toList());
  } else if (contact is GroupContact) {
    final memberIds = contact.memberIds.toList();
    final memberCount = memberIds.length;
    final maxMessageCount = RandomUtils.nextInt() % 20;
    final messages = <ChatMessage>[];
    var date = endDate;
    for (var i = 0; i < maxMessageCount; i++) {
      final memberId = memberIds[RandomUtils.nextInt() % memberCount];
      final messages = contactToMessages[memberId]!;
      final messageCount = messages.length;
      if (messageCount == 0) {
        continue;
      }
      final message = messages[RandomUtils.nextInt() % messageCount];
      date = date.add(Duration(seconds: random.nextInt(60 * 60 * 24 * 500)));
      ChatMessage(
          messageId: RandomUtils.nextUniqueInt64(),
          senderId: memberId,
          // TODO
          sentByMe: false,
          text: message,
          timestamp: date,
          status: MessageDeliveryStatus.delivered);
    }
    return GroupConversation(
        contact: contact,
        unreadMessageCount:
            messages.isEmpty ? 0 : random.nextInt(messages.length),
        messages: messages);
  } else {
    throw Exception('Unknown contact type');
  }
}).toList();