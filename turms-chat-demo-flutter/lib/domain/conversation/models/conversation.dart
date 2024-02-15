import 'package:flutter/cupertino.dart';

import '../../../ui/pages/home_page/chat_page/chat_session_pane/message.dart';

abstract class Conversation {
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
}