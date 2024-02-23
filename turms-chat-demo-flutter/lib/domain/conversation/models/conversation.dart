import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';

import '../../../ui/pages/home_page/chat_page/chat_session_pane/message.dart';
import '../../user/models/contact.dart';
import '../../user/models/group_contact.dart';
import '../../user/models/user_contact.dart';
import 'group_conversation.dart';
import 'private_conversation.dart';

abstract class Conversation {
  factory Conversation.from(
      {required Contact contact, required List<ChatMessage> messages}) {
    if (contact is UserContact) {
      return PrivateConversation(contact: contact, messages: messages);
    } else if (contact is GroupContact) {
      return GroupConversation(contact: contact, messages: messages);
    } else {
      throw Exception('Unsupported contact type: ${contact.runtimeType}');
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

  abstract ImageProvider? image;

  bool hasSameContact(Contact contact);
}
