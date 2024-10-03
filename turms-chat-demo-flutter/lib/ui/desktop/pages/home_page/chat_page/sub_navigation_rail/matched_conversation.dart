import 'package:flutter/widgets.dart';

import '../../../../../../domain/conversation/models/conversation.dart';
import '../chat_session_pane/message.dart';

class StyledConversation {
  const StyledConversation(
      {required this.conversation,
      required this.matchedMessages,
      required this.nameTextSpans});

  final Conversation conversation;
  final List<ChatMessage> matchedMessages;
  final List<TextSpan> nameTextSpans;
}
