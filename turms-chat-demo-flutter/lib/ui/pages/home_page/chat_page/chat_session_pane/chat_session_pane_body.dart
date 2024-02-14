import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/conversation/models/conversation.dart';
import '../../../../../domain/conversation/models/private_conversation.dart';
import '../../../../../domain/user/models/user.dart';
import '../../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../../../fixtures/contacts.dart';
import '../../../../themes/theme_config.dart';
import '../message_bubble.dart';

class ChatSessionPaneBody extends ConsumerStatefulWidget {
  const ChatSessionPaneBody(this.selectedConversation, {super.key});

  final Conversation selectedConversation;

  @override
  ConsumerState<ChatSessionPaneBody> createState() =>
      _ChatSessionPaneBodyState();
}

class _ChatSessionPaneBodyState extends ConsumerState<ChatSessionPaneBody> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final position = _scrollController.position;
      final pixels = position.pixels;
      if (pixels == position.maxScrollExtent) {
        // User has scrolled to the top
        // Display loading message and load more messages
        _loadMoreMessages();
      } else if (pixels == position.minScrollExtent) {}
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedConversation = widget.selectedConversation;
    final messages = selectedConversation.messages;
    return ColoredBox(
        color: ThemeConfig.homePageBackgroundColor,
        child: messages.isEmpty
            ? null
            : _buildMessageBubbles(selectedConversation));
  }

  ListView _buildMessageBubbles(Conversation conversation) {
    final loggedInUser = ref.watch(loggedInUserViewModel)!;
    final messages = conversation.messages;
    final messageCount = messages.length;
    // +1 for the loading indicator
    final itemCount = messageCount + 1;
    final lastItemIndex = itemCount - 1;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      controller: _scrollController,
      reverse: true,
      // Reverse the list to display conversations from bottom to top
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == lastItemIndex) {
          if (isLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CupertinoActivityIndicator(radius: 8),
            );
          } else {
            return const Center(
              child: Text('Load More Messages'),
            );
          }
        }
        // Calculate the actual index in the conversations list
        final actualIndex = itemCount - index - 2;
        final message = messages[actualIndex];
        final User user;
        if (message.sentByMe) {
          user = loggedInUser;
        } else if (conversation is PrivateConversation) {
          user = conversation.contact;
        } else {
          // TODO: find from group users
          user = fixtureUserContacts
              .firstWhere((element) => element.userId == message.senderId);
        }
        return MessageBubble(
          key: UniqueKey(), // TODO: use message ID
          user: user,
          message: message,
        );
      },
    );
  }

  void _loadMoreMessages() {
    if (isLoading) {
      return;
    }
    isLoading = true;
    setState(() {});
    // Simulate loading messages
    Future.delayed(const Duration(seconds: 2), () {
      // final newMessages = List<String>.generate(
      //     10, (index) => 'New Message ${messages.length + index}');
      // messages.insertAll(0, newMessages);

      isLoading = false;
      setState(() {});
    });
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }
}