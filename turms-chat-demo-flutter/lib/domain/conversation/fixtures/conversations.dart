import 'dart:math';

import 'package:fixnum/fixnum.dart';

import '../../../infra/random/random_utils.dart';
import '../../../ui/desktop/pages/home_page/chat_page/chat_session_pane/message.dart';
import '../../message/models/message_delivery_status.dart';
import '../../user/fixtures/contacts.dart';
import '../../user/models/index.dart';
import '../models/conversation.dart';

final random = Random(123456789);

const _deliveryStatuses = MessageDeliveryStatus.values;

final fixtureConversations = fixtureContacts.map((contact) {
  final now = DateTime.now();
  switch (contact) {
    case UserContact():
      final timestamps = <DateTime>[];
      final messages = contactToMessages[contact.userId]!;
      final count = messages.length;
      var date = now;
      for (var i = 0; i < count; i++) {
        date =
            date.subtract(Duration(seconds: random.nextInt(60 * 60 * 24 * 30)));
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
                timestamp: timestamps[count - messageIndex - 1],
                status: sentByMe
                    ? _deliveryStatuses[
                        random.nextInt(_deliveryStatuses.length)]
                    : MessageDeliveryStatus.delivered);
          }).toList());
    case GroupContact():
      final memberIds = contact.members.map((member) => member.userId).toList();
      final memberCount = memberIds.length;
      final maxMessageCount = RandomUtils.nextInt() % 20;
      final messages = <ChatMessage>[];
      var date = now;
      final timestamps = <DateTime>[];
      for (var i = 0; i < maxMessageCount; i++) {
        date =
            date.subtract(Duration(seconds: random.nextInt(60 * 60 * 24 * 30)));
        timestamps.add(date);
      }
      for (var i = 0; i < maxMessageCount; i++) {
        final memberId = memberIds[RandomUtils.nextInt() % memberCount];
        final messageStrings = contactToMessages[memberId]!;
        final messageCount = messageStrings.length;
        if (messageCount == 0) {
          continue;
        }
        final message = messageStrings[RandomUtils.nextInt() % messageCount];
        messages.add(ChatMessage.parse(message,
            messageId: -RandomUtils.nextUniquePositiveInt64(),
            senderId: memberId,
            // TODO
            sentByMe: false,
            isGroupMessage: true,
            timestamp: timestamps[maxMessageCount - i - 1],
            status: MessageDeliveryStatus.delivered));
      }
      return GroupConversation(
          contact: contact,
          unreadMessageCount:
              messages.isEmpty ? 0 : random.nextInt(messages.length),
          messages: messages);
    case SystemContact():
      throw UnimplementedError();
  }
}).toList();
