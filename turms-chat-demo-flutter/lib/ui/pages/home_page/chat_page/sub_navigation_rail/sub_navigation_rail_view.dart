import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/theme_config.dart';
import '../../shared_components/conversation.dart';
import 'sub_navigation_rail_controller.dart';

class SubNavigationRailView extends StatelessWidget {
  const SubNavigationRailView(this.subNavigationRailController, {super.key});

  final SubNavigationRailController subNavigationRailController;

  @override
  Widget build(BuildContext context) => ColoredBox(
      color: ThemeConfig.conversationBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(context),
          if (subNavigationRailController.isConversationsLoading)
            _buildLoadingIndicator(),
          _buildConversations(context)
        ],
      ));

  Container _buildLoadingIndicator() => Container(
        alignment: AlignmentDirectional.center,
        height: 40,
        color: const Color.fromARGB(255, 237, 237, 237),
        child: const CupertinoActivityIndicator(radius: 8),
      );

  Container _buildSearchBar(BuildContext context) => Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: const Color.fromARGB(255, 247, 247, 247),
        alignment: Alignment.center,
        child: Container(
          // height: 26,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: subNavigationRailController.appLocalizations.search,
              filled: true,
              fillColor: const Color.fromARGB(255, 226, 226, 226),
              prefixIcon: const Icon(Symbols.search),
              border: InputBorder.none,
            ),
          ),
        ),
      );

  Expanded _buildConversations(BuildContext context) {
    final conversations = subNavigationRailController.conversations;
    return Expanded(
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeLeft: true,
            removeRight: true,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: conversations.length,
              prototypeItem: Conversation(
                conversation: ConversationData(
                  isGroupConversation: false,
                  fromId: Int64(),
                  contactName: '',
                  messages: [],
                ),
                backgroundColor: ThemeConfig.conversationBackgroundColor,
                hoverBackgroundColor: ThemeConfig.conversationBackgroundColor,
                onTap: () {},
              ),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final selectedConversationId =
                    subNavigationRailController.selectedConversation?.id;
                return Conversation(
                  conversation: conversation,
                  backgroundColor: selectedConversationId == conversation.id
                      ? ThemeConfig.conversationFocusBackgroundColor
                      : ThemeConfig.conversationBackgroundColor,
                  hoverBackgroundColor:
                      selectedConversationId == conversation.id
                          ? ThemeConfig.conversationFocusBackgroundColor
                          : ThemeConfig.conversationHoverBackgroundColor,
                  onTap: () {
                    subNavigationRailController
                        .selectConversation(conversation);
                  },
                );
              },
            )));
  }
}