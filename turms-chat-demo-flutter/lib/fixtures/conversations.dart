import 'package:fixnum/fixnum.dart';

import '../ui/pages/home_page/chat_page/message.dart';
import '../ui/pages/home_page/shared_components/conversation.dart';

final fixtureConversations = [
  ConversationData(
      isGroupConversation: false,
      fromId: Int64(1),
      contactName: 'Contact 1',
      messages: [
        ChatMessage(text: 'A chat message 1'),
        ChatMessage(text: 'A chat message 2')
      ]),
  ConversationData(
      isGroupConversation: false,
      fromId: Int64(2),
      contactName: 'Contact 2',
      messages: [ChatMessage(text: 'B chat message 1')]),
  ConversationData(
      isGroupConversation: false,
      fromId: Int64(3),
      contactName: 'Contact 3',
      messages: [
        ChatMessage(text: 'C chat message 1'),
        ChatMessage(text: 'C chat message 2'),
        ChatMessage(text: 'C chat message 3')
      ]),
];