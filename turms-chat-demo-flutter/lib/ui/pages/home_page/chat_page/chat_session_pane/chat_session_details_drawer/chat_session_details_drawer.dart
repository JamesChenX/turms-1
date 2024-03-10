import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/conversation/models/conversation.dart';
import '../../../../../../domain/conversation/models/private_conversation.dart';
import '../../../../../../domain/user/models/index.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../../themes/theme_config.dart';
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
                left: BorderSide(width: 1, color: ThemeConfig.borderColor),
              )),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: conversation is PrivateConversation
                ? ChatSessionDetailsPrivateConversation(
                    contact: conversation.contact as UserContact,
                  )
                : ChatSessionDetailsGroupConversation(
                    contact: conversation.contact as GroupContact,
                  ),
          ),
        ),
      );
}
