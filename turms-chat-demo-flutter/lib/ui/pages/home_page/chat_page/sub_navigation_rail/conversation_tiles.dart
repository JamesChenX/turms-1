import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/conversation/models/conversation.dart';
import '../../../../../domain/conversation/models/private_conversation.dart';
import '../../../../../domain/user/models/index.dart';
import '../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../infra/ui/text_utils.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../themes/theme_config.dart';
import '../chat_session_pane/message.dart';
import 'conversation_tile.dart';
import 'sub_navigation_rail_controller.dart';

class ConversationTiles extends ConsumerStatefulWidget {
  ConversationTiles({Key? key, required this.subNavigationRailController})
      : super(key: key);

  final SubNavigationRailController subNavigationRailController;

  @override
  ConsumerState<ConversationTiles> createState() => _ConversationTilesState();
}

class _ConversationTilesState extends ConsumerState<ConversationTiles> {
  String previousSearchText = '';
  List<(Conversation, List<TextSpan>, List<ChatMessage>)>
      conversationsInSearchMode = [];

  @override
  Widget build(BuildContext context) {
    final subNavigationRailController = widget.subNavigationRailController;
    final searchText = subNavigationRailController.searchText;
    final isSearchMode = searchText.isNotBlank;
    // If searching and search text doesn't change,
    // keep displaying the snapshot of conversations of last search result
    // because it is a weired behavior if the found conversations change
    // as new messages are added while searching.
    List<(Conversation, List<TextSpan>, List<ChatMessage>)> parsedConversations;
    if (isSearchMode && searchText == previousSearchText) {
      parsedConversations = conversationsInSearchMode;
    } else {
      final subNavigationRailController = widget.subNavigationRailController;
      parsedConversations = subNavigationRailController.conversations
          .expand<(Conversation, List<TextSpan>, List<ChatMessage>)>(
              (conversation) {
        final nameTextSpans = TextUtils.splitText(
            text: conversation.name,
            searchText: searchText,
            searchTextStyle: ThemeConfig.textStyleHighlight);
        final matchedMessages = isSearchMode
            ? conversation.messages
                .where((message) => message.text
                    .toLowerCase()
                    .contains(searchText.toLowerCase()))
                .toList()
            : <ChatMessage>[];
        if (nameTextSpans.length == 1 &&
            matchedMessages.isEmpty &&
            isSearchMode) {
          return [];
        }
        return [(conversation, nameTextSpans, matchedMessages)];
      }).toList();
      if (isSearchMode) {
        previousSearchText = searchText;
        conversationsInSearchMode = parsedConversations;
      } else {
        previousSearchText = '';
        conversationsInSearchMode = [];
      }
    }
    final relatedMessages =
        ref.watch(appLocalizationsViewModel).relatedMessages;
    subNavigationRailController.conversationIdToContext.clear();
    // Don't use "ScrollablePositionedList" because it's buggy.
    // e.g. https://github.com/google/flutter.widgets/issues/276
    final conversationCount = parsedConversations.length;
    final conversationIdToIndex = {
      for (var i = 0; i < conversationCount; i++)
        parsedConversations[i].$1.id: i
    };
    return ListView.builder(
      controller: subNavigationRailController.scrollController,
      padding: EdgeInsets.zero,
      itemCount: conversationCount,
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
      findChildIndexCallback: (key) =>
          conversationIdToIndex[(key as ValueKey<String>).value],
      itemBuilder: (context, index) {
        final (conversation, nameTextSpans, matchedMessages) =
            parsedConversations[index];
        final selectedConversationId =
            subNavigationRailController.selectedConversation?.id;
        subNavigationRailController.conversationIdToContext[conversation.id] =
            context;
        return ConversationTile(
          key: Key(conversation.id),
          conversation: conversation,
          selected: selectedConversationId == conversation.id,
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
