import 'dart:math';

import 'package:fixnum/fixnum.dart';

import '../../../infra/random/random_utils.dart';
import '../../../ui/desktop/pages/home_page/chat_page/chat_session_pane/message.dart';
import '../../message/models/message_delivery_status.dart';
import '../../user/fixtures/contacts.dart';
import '../../user/models/index.dart';
import '../models/conversation.dart';

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
          return ChatMessage.parse(message,
              messageId: -RandomUtils.nextUniquePositiveInt64(),
              senderId: sentByMe ? Int64.MIN_VALUE : contact.userId,
              sentByMe: sentByMe,
              isGroupMessage: false,
              timestamp: timestamps[messageIndex],
              status: sentByMe
                  ? _deliveryStatuses[random.nextInt(_deliveryStatuses.length)]
                  : MessageDeliveryStatus.delivered);
        }).toList());
  } else if (contact is GroupContact) {
    final memberIds = contact.members.map((member) => member.userId).toList();
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
      ChatMessage.parse(message,
          messageId: -RandomUtils.nextUniquePositiveInt64(),
          senderId: memberId,
          // TODO
          sentByMe: false,
          isGroupMessage: true,
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