import 'package:flutter/material.dart';

import '../../../../../../../domain/conversation/models/conversation.dart';
import '../../../../../../themes/index.dart';

import 'chat_session_details_group_conversation.dart';
import 'chat_session_details_private_conversation.dart';

class ChatSessionDetailsDrawer extends StatelessWidget {
  const ChatSessionDetailsDrawer({super.key, required this.conversation});

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final appThemeExtension = theme.appThemeExtension;
    return SizedBox(
      width: Sizes.subNavigationRailWidth,
      height: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: appThemeExtension.chatSessionDetailsDrawerBackgroundColor,
            border: Border(
              left: BorderSide(color: theme.dividerColor),
            )),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
          child: switch (conversation) {
            final PrivateConversation c =>
              ChatSessionDetailsPrivateConversation(contact: c.contact),
            final GroupConversation c => ChatSessionDetailsGroupConversation(
                contact: c.contact,
              ),
          },
        ),
      ),
    );
  }
}
