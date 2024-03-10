import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';

import '../../../ui/pages/home_page/chat_page/chat_session_pane/message.dart';
import '../../user/models/contact.dart';
import 'group_conversation.dart';
import 'private_conversation.dart';

abstract class Conversation {
  factory Conversation.from(
      {required Contact contact, required List<ChatMessage> messages}) {
    switch (contact) {
      case UserContact():
        return PrivateConversation(contact: contact, messages: messages);
      case GroupContact():
        return GroupConversation(contact: contact, messages: messages);
      case SystemContact():
        return PrivateConversation(
            messages: messages,
            contact: UserContact(userId: Int64(-1), name: contact.name));
    }
  }

  Conversation(
      {required this.id,
      required this.name,
      required this.messages,
      this.unreadMessageCount = 0,
      this.draft});

  final String id;
  final String name;
  final List<ChatMessage> messages;
  int unreadMessageCount;
  String? draft;

  abstract Contact contact;
  abstract ImageProvider? image;

  bool hasSameContact(Contact contact);
}
