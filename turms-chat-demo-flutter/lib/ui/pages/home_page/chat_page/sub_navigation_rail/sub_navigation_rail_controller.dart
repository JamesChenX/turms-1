import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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
import '../../../../../infra/notification/notification_utils.dart';
import '../../../../../infra/random/random_utils.dart';
import '../../../../../infra/window/window_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../chat_session_pane/message.dart';
import '../view_models/conversations_view_model.dart';
import '../view_models/is_conversations_initialized_view_model.dart';
import '../view_models/selected_conversation_view_model.dart';
import 'sub_navigation_rail.dart';
import 'sub_navigation_rail_view.dart';

class SubNavigationRailController extends ConsumerState<SubNavigationRail> {
  late FocusNode focusNode;
  late MenuController menuController;
  late ScrollController scrollController;

  late AppLocalizations appLocalizations;
  late List<Conversation> conversations;
  Map<String, BuildContext> conversationIdToContext = {};
  Conversation? selectedConversation;
  bool isConversationsInitialized = false;
  bool isConversationsLoading = false;

  String searchText = '';

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    menuController = MenuController();
    scrollController = ScrollController();
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
    scrollController.dispose();
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
      final context = conversationIdToContext[conversationId];
      if (context == null) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          final context = conversationIdToContext[conversationId];
          if (context != null) {
            Scrollable.ensureVisible(context);
            return;
          }
          final conversationIndex = conversations
              .indexWhere((element) => element.id == conversationId);
          if (conversationIndex == -1) {
            return;
          }
          final itemContext = conversationIdToContext.values.firstOrNull;
          if (itemContext == null) {
            return;
          }
          final box = itemContext.findRenderObject() as RenderBox;
          // TODO: alignment
          scrollController.jumpTo(box.size.height * conversationIndex);
        });
      } else {
        Scrollable.ensureVisible(context);
      }
    }
    return SubNavigationRailView(this);
  }

  void selectConversation(Conversation conversation) {
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

  void updateSearchText(String value) {
    searchText = value.toLowerCase().trim();
    setState(() {});
  }

  KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) {
    final selectedConversation = this.selectedConversation;
    if (selectedConversation == null) {
      return KeyEventResult.ignored;
    }
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final isArrowUp = event.logicalKey == LogicalKeyboardKey.arrowUp;
    final isArrowDown = event.logicalKey == LogicalKeyboardKey.arrowDown;
    if (!isArrowUp && !isArrowDown) {
      return KeyEventResult.ignored;
    }
    final conversationIndex = conversations
        .indexWhere((element) => element.id == selectedConversation.id);
    if (isArrowUp) {
      if (conversationIndex > 0) {
        selectConversation(conversations[conversationIndex - 1]);
      }
    } else {
      if (conversationIndex < conversations.length - 1) {
        selectConversation(conversations[conversationIndex + 1]);
      }
    }
    return KeyEventResult.handled;
  }

  void onPanDown(DragDownDetails details) {
    focusNode.requestFocus();
  }
}
