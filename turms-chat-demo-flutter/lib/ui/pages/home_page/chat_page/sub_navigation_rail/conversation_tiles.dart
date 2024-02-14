import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/conversation/models/conversation.dart';
import '../../../../../domain/conversation/models/private_conversation.dart';
import '../../../../../domain/user/models/user_contact.dart';
import '../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../infra/ui/text_utils.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../themes/theme_config.dart';
import '../message.dart';
import 'conversation_tile.dart';
import 'sub_navigation_rail_controller.dart';

class ConversationTiles extends ConsumerWidget {
  const ConversationTiles({Key? key, required this.subNavigationRailController})
      : super(key: key);

  final SubNavigationRailController subNavigationRailController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = subNavigationRailController.conversations
        .expand<(Conversation, List<TextSpan>, List<ChatMessage>)>(
            (conversation) {
      final searchText = subNavigationRailController.searchText;
      final nameTextSpans = TextUtils.splitText(
          text: conversation.name,
          searchText: searchText,
          searchTextStyle: ThemeConfig.textStyleHighlight);
      final matchedMessages = searchText.isBlank
          ? <ChatMessage>[]
          : conversation.messages
              .where((message) =>
                  message.text.toLowerCase().contains(searchText.toLowerCase()))
              .toList();
      if (nameTextSpans.length == 1 &&
          matchedMessages.isEmpty &&
          searchText.isNotBlank) {
        return [];
      }
      return [(conversation, nameTextSpans, matchedMessages)];
    }).toList();
    final relatedMessages =
        ref.watch(appLocalizationsViewModel).relatedMessages;
    final isSearchMode = subNavigationRailController.searchText.isNotBlank;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: conversations.length,
      prototypeItem: ConversationTile(
        conversation: PrivateConversation(
          contact: UserContact(
              userId: Int64(), name: '', relationshipGroupId: Int64()),
          messages: [],
        ),
        isSearchMode: false,
        nameTextSpans: [],
        messageTextSpans: [],
        onTap: () {},
      ),
      itemBuilder: (context, index) {
        final (conversation, nameTextSpans, matchedMessages) =
            conversations[index];
        final selectedConversationId =
            subNavigationRailController.selectedConversation?.id;
        subNavigationRailController.conversationIdToContext[conversation.id] =
            context;
        return ConversationTile(
          key: Key(conversation.id),
          conversation: conversation,
          focused: selectedConversationId == conversation.id,
          isSearchMode: isSearchMode,
          nameTextSpans: nameTextSpans,
          messageTextSpans: isSearchMode
              ? switch (matchedMessages.length) {
                  0 => [],
                  1 => TextUtils.splitText(
                      text: matchedMessages[0].text,
                      searchText: subNavigationRailController.searchText,
                      searchTextStyle: ThemeConfig.textStyleHighlight),
                  _ => [TextSpan(text: relatedMessages(matchedMessages.length))]
                }
              : [],
          onTap: () {
            subNavigationRailController.selectConversation(conversation);
          },
        );
      },
    );
  }
}