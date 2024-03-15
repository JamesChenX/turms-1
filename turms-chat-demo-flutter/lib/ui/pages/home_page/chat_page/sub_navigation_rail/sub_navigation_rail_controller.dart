import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/conversation/models/conversation.dart';
import '../../../../../domain/conversation/models/group_conversation.dart';
import '../../../../../domain/conversation/models/private_conversation.dart';
import '../../../../../domain/message/models/message_delivery_status.dart';
import '../../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../../../domain/user/view_models/user_settings_view_model.dart';
import '../../../../../domain/conversation/fixtures/conversations.dart';
import '../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../infra/notification/notification_utils.dart';
import '../../../../../infra/random/random_utils.dart';
import '../../../../../infra/ui/scroll_utils.dart';
import '../../../../../infra/ui/text_utils.dart';
import '../../../../../infra/window/window_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../themes/theme_config.dart';
import '../chat_session_pane/message.dart';
import '../view_models/conversations_view_model.dart';
import '../view_models/is_conversations_initialized_view_model.dart';
import '../view_models/selected_conversation_view_model.dart';
import 'matched_conversation.dart';
import 'sub_navigation_rail.dart';
import 'sub_navigation_rail_view.dart';

class SubNavigationRailController extends ConsumerState<SubNavigationRail> {
  late FocusNode focusNode;
  late MenuController menuController;
  late TextEditingController searchBarTextEditingController;
  late ScrollController conversationTilesScrollController;
  BuildContext? conversationTilesBuildContext;

  late AppLocalizations appLocalizations;
  late List<Conversation> conversations;
  List<StyledConversation> styledConversations = [];
  Conversation? selectedConversation;
  int? highlightedStyledConversationIndex;
  bool isConversationsInitialized = false;
  bool isConversationsLoading = false;

  bool isSearchMode = false;
  String previousSearchText = '';
  String searchText = '';

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    menuController = MenuController();
    searchBarTextEditingController = TextEditingController();
    conversationTilesScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (conversations.isNotEmpty) {
        return;
      }
      conversations = ref.watch(conversationsViewModel);
      if (isConversationsLoading) {
        return;
      }
      final isConversationsInitialized =
          ref.read(isConversationsInitializedViewModel);
      if (!isConversationsInitialized) {
        loadConversations();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    searchBarTextEditingController.dispose();
    conversationTilesScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    conversations = ref.watch(conversationsViewModel);
    final previousSelectedConversationId = selectedConversation?.id;
    selectedConversation = ref.watch(selectedConversationViewModel);
    final conversationId = selectedConversation?.id;
    if (conversationId != null &&
        previousSelectedConversationId != conversationId) {
      final conversationIndex =
          conversations.indexWhere((element) => element.id == conversationId);
      if (conversationIndex >= 0) {
        _scrollTo(conversationIndex);
      }
    }

    isSearchMode = searchText.isNotBlank;
    if (isSearchMode) {
      // If searching and search text doesn't change,
      // keep displaying the snapshot of conversations of last search result
      // because it is a weired behavior if the matched conversations change
      // as new messages are added while searching.
      if (searchText != previousSearchText) {
        styledConversations =
            conversations.expand<StyledConversation>((conversation) {
          final nameTextSpans = TextUtils.splitText(
              text: conversation.name,
              searchText: searchText,
              searchTextStyle: ThemeConfig.textStyleHighlight);
          final matchedMessages = conversation.messages
              .where((message) =>
                  message.text.toLowerCase().contains(searchText.toLowerCase()))
              .toList();
          if (nameTextSpans.length == 1 && matchedMessages.isEmpty) {
            return [];
          }
          return [
            StyledConversation(
              conversation: conversation,
              matchedMessages: matchedMessages,
              nameTextSpans: nameTextSpans,
            )
          ];
        }).toList();
        highlightedStyledConversationIndex =
            styledConversations.isEmpty ? null : 0;
        previousSearchText = searchText;
      }
      final conversationIndex = highlightedStyledConversationIndex;
      if (conversationIndex != null) {
        _scrollTo(conversationIndex);
      }
    } else {
      styledConversations = conversations
          .expand<StyledConversation>((conversation) => [
                StyledConversation(
                  conversation: conversation,
                  matchedMessages: [],
                  nameTextSpans: [TextSpan(text: conversation.name)],
                )
              ])
          .toList();
      previousSearchText = '';
      highlightedStyledConversationIndex = null;
    }
    return SubNavigationRailView(this);
  }

  void _scrollTo(int conversationIndex) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final itemContext = conversationTilesBuildContext;
      if (itemContext == null) {
        return;
      }
      final renderObject =
          itemContext.findRenderObject() as RenderSliverFixedExtentBoxAdaptor;
      final itemHeight = renderObject.itemExtent!;
      ScrollUtils.ensureVisible(
          conversationTilesScrollController,
          renderObject.constraints.viewportMainAxisExtent,
          itemHeight * conversationIndex,
          itemHeight);
    });
  }

  void selectConversation(Conversation conversation) {
    if (isSearchMode) {
      searchBarTextEditingController.clear();
      onSearchTextUpdated('');
      highlightedStyledConversationIndex = null;
    }
    conversation.unreadMessageCount = 0;
    ref.read(selectedConversationViewModel.notifier).state = conversation;
  }

  Future<void> loadConversations() async {
    isConversationsLoading = true;
    setState(() {});
    // TODO: use real API
    await Future.delayed(const Duration(seconds: 3));
    ref.read(conversationsViewModel.notifier).state = fixtureConversations;
    ref.read(isConversationsInitializedViewModel.notifier).state = true;
    isConversationsInitialized = true;
    isConversationsLoading = false;
    setState(() {});

    final random = Random();
    Timer.periodic(
      const Duration(seconds: 3),
      (timer) => _generateFakeMessage(timer, random),
    );
  }

  void _generateFakeMessage(Timer timer, Random random) {
    if (!mounted) {
      timer.cancel();
      return;
    }
    final conversations = ref.read(conversationsViewModel.notifier).state;
    final conversationCount = conversations.length;
    if (conversationCount == 0) {
      return;
    }

    final fakeMessage = StringBuffer();
    for (var i = 0; i < 1 + random.nextInt(200); i++) {
      fakeMessage.writeCharCode(32 + random.nextInt(10000));
    }
    final message = 'fake messages: $fakeMessage';

    final loggedInUser = ref.read(loggedInUserViewModel)!;
    int conversationIndexForUpdating;
    Conversation conversation;
    while (true) {
      conversationIndexForUpdating = random.nextInt(conversationCount);
      conversation = conversations[conversationIndexForUpdating];
      final now = DateTime.now();
      if (conversation is PrivateConversation) {
        final contactId = conversation.contact.userId;
        if (contactId != loggedInUser.userId) {
          conversation.messages.add(ChatMessage(
              messageId: RandomUtils.nextUniqueInt64(),
              senderId: contactId,
              sentByMe: false,
              text: message,
              timestamp: now,
              status: MessageDeliveryStatus.delivered));
          onMessageReceived(message, conversation, conversations,
              conversationIndexForUpdating);
          return;
        }
      } else if (conversation is GroupConversation &&
          conversation.contact.memberIds.length > 1) {
        final memberIds = conversation.contact.memberIds;
        final senderId =
            memberIds.firstWhere((memberId) => memberId != loggedInUser.userId);
        conversation.messages.add(ChatMessage(
            messageId: RandomUtils.nextUniqueInt64(),
            senderId: senderId,
            sentByMe: false,
            text: message,
            timestamp: now,
            status: MessageDeliveryStatus.delivered));
        onMessageReceived(
            message, conversation, conversations, conversationIndexForUpdating);
        break;
      }
      if (conversationCount == 1) {
        return;
      }
    }
  }

  void onMessageReceived(String message, Conversation newConversation,
      List<Conversation> conversations, int conversationIndexForUpdating) {
    if (conversations[0].id != newConversation.id) {
      conversations.insert(
          0, conversations.removeAt(conversationIndexForUpdating));
    }
    final selectedConversation = ref.read(selectedConversationViewModel);
    if (selectedConversation?.id == newConversation.id) {
      ref.read(selectedConversationViewModel.notifier).notifyListeners();
    } else {
      newConversation.unreadMessageCount++;
    }

    if (ref.read(userSettingsViewModel)?.newMessageNotification ?? false) {
      WindowUtils.isVisible().then((isVisible) {
        if (!isVisible) {
          NotificationUtils.showNotification(newConversation.name, message);
        }
      });
    }
    conversationsViewModelRef.notifyListeners();
  }

  void onSearchTextUpdated(String value) {
    searchText = value.toLowerCase().trim();
    setState(() {});
  }

  KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final isArrowUp = event.logicalKey == LogicalKeyboardKey.arrowUp;
    final isArrowDown = event.logicalKey == LogicalKeyboardKey.arrowDown;
    if (!isArrowUp && !isArrowDown) {
      return KeyEventResult.ignored;
    }
    final conversationIndex = highlightedStyledConversationIndex;
    if (conversationIndex == null) {
      return KeyEventResult.handled;
    }
    if (isArrowUp) {
      if (conversationIndex > 0) {
        highlightedStyledConversationIndex = conversationIndex - 1;
        setState(() {});
      }
    } else {
      if (conversationIndex < styledConversations.length - 1) {
        highlightedStyledConversationIndex = conversationIndex + 1;
        setState(() {});
      }
    }
    return KeyEventResult.handled;
  }

  void onPanDown(DragDownDetails details) {
    focusNode.requestFocus();
  }

  void onSearchSubmitted() {
    final conversationIndex = highlightedStyledConversationIndex;
    if (conversationIndex != null &&
        conversationIndex < styledConversations.length) {
      final conversation = styledConversations[conversationIndex];
      selectConversation(conversation.conversation);
    }
    setState(() {});
  }
}
