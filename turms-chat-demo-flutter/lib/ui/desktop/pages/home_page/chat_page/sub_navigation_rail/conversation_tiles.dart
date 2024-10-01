import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/conversation/models/conversation.dart';
import '../../../../../../domain/user/models/index.dart';
import '../../../../../../infra/ui/text_utils.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../../themes/theme_config.dart';
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
  @override
  Widget build(BuildContext context) {
    final subNavigationRailController = widget.subNavigationRailController;
    final relatedMessages =
        ref.watch(appLocalizationsViewModel).relatedMessages;
    subNavigationRailController.conversationTilesBuildContext = null;
    // Don't use "ScrollablePositionedList" because it's buggy.
    // e.g. https://github.com/google/flutter.widgets/issues/276
    final styledConversations = subNavigationRailController.styledConversations;
    final conversationCount = styledConversations.length;
    final conversationIdToIndex = {
      for (var i = 0; i < conversationCount; i++)
        styledConversations[i].conversation.id: i
    };
    return ListView.builder(
      controller: subNavigationRailController.conversationTilesScrollController,
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
        final styledConversation = styledConversations[index];
        final conversation = styledConversation.conversation;
        final selectedConversationId =
            subNavigationRailController.selectedConversation?.id;
        subNavigationRailController.conversationTilesBuildContext ??= context;
        return ConversationTile(
          key: Key(conversation.id),
          conversation: conversation,
          selected: selectedConversationId == conversation.id,
          highlighted:
              subNavigationRailController.highlightedStyledConversationIndex ==
                  index,
          isSearchMode: subNavigationRailController.isSearchMode,
          nameTextSpans: styledConversation.nameTextSpans,
          messageTextSpans: subNavigationRailController.isSearchMode
              ? switch (styledConversations.length) {
                  0 => [],
                  1 => TextUtils.highlightSearchText(
                      text: conversation.messages[0].text,
                      searchText: subNavigationRailController.searchText,
                      searchTextStyle: ThemeConfig.textStyleHighlight),
                  _ => [
                      TextSpan(
                          text: relatedMessages(conversation.messages.length))
                    ]
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
