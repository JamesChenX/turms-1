import 'package:flutter/material.dart';

import '../../../../../../../domain/conversation/models/conversation.dart';
import '../../../../../../themes/theme_config.dart';
import 'chat_session_details_group_conversation.dart';
import 'chat_session_details_private_conversation.dart';

class ChatSessionDetailsDrawer extends StatelessWidget {
  const ChatSessionDetailsDrawer({super.key, required this.conversation});

  final Conversation conversation;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: ThemeConfig.subNavigationRailWidth,
        height: double.infinity,
        child: DecoratedBox(
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: ThemeConfig.borderColor),
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