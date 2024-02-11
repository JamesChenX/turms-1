import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/conversation/models/private_conversation.dart';
import '../../../../../domain/user/models/user_contact.dart';
import 'conversation_tile.dart';
import 'sub_navigation_rail_controller.dart';

class ConversationTiles extends StatelessWidget {
  const ConversationTiles({Key? key, required this.subNavigationRailController})
      : super(key: key);

  final SubNavigationRailController subNavigationRailController;

  @override
  Widget build(BuildContext context) {
    final conversations = subNavigationRailController.conversations;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: conversations.length,
      prototypeItem: ConversationTile(
        conversation: PrivateConversation(
          contact: UserContact(
              userId: Int64(), name: '', relationshipGroupId: Int64()),
          messages: [],
        ),
        onTap: () {},
      ),
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        final selectedConversationId =
            subNavigationRailController.selectedConversation?.id;
        subNavigationRailController.conversationIdToContext[conversation.id] =
            context;
        return ConversationTile(
          key: Key(conversation.id),
          conversation: conversation,
          focused: selectedConversationId == conversation.id,
          onTap: () {
            subNavigationRailController.selectConversation(conversation);
          },
        );
      },
    );
  }
}