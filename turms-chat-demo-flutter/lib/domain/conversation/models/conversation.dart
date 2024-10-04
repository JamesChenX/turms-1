import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';

import '../../../ui/desktop/pages/home_page/chat_page/chat_session_pane/message.dart';
import '../../user/models/contact.dart';

part './group_conversation.dart';

part './private_conversation.dart';

sealed class Conversation {
  factory Conversation.from(
          {required Contact contact, required List<ChatMessage> messages}) =>
      switch (contact) {
        UserContact() =>
          PrivateConversation(contact: contact, messages: messages),
        GroupContact() =>
          GroupConversation(contact: contact, messages: messages),
        SystemContact() => PrivateConversation(
            messages: messages,
            contact: UserContact(userId: Int64(-1), name: contact.name))
      };

  Conversation(
      {required this.id,
      required this.name,
      required this.messages,
      this.unreadMessageCount = 0,
      this.draft});

  final String id;
  final String name;

  /// Note that the messages should be sorted by timestamp in ascending order.
  final List<ChatMessage> messages;
  int unreadMessageCount;
  String? draft;

  abstract Contact contact;
  abstract ImageProvider? image;

  bool hasSameContact(Contact contact);
}
