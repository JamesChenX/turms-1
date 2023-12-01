import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turms_chat_demo/ui/pages/home_page/chat_page/message.dart';

import '../shared_states/shared_states.dart';
import 'message_bubble.dart';

class ChatPageBody extends ConsumerStatefulWidget {
  const ChatPageBody({super.key});

  @override
  ConsumerState<ChatPageBody> createState() => _ChatPageBodyState();
}

class _ChatPageBodyState extends ConsumerState<ChatPageBody> {
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
    final conversation = ref.watch(selectedConversationViewModel);
    final messages = conversation?.messages ?? [];
    return ColoredBox(
        color: const Color.fromARGB(255, 245, 245, 245),
        child: messages.isEmpty ? null : _buildMessageBubbles(messages));
  }

  ListView _buildMessageBubbles(List<ChatMessage> messages) {
    final messageCount = messages.length;
    // +1 for the loading indicator
    final itemCount = messageCount + 1;
    final lastItemIndex = itemCount - 1;
    final listView = ListView.builder(
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
        return MessageBubble(
          key: UniqueKey(),
          message: messages[actualIndex].text,
          isMyMessage: actualIndex.isEven,
        );
      },
    );
    return listView;
  }

  void _loadMoreMessages() {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    // Simulate loading messages
    Future.delayed(const Duration(seconds: 2), () {
      // final newMessages = List<String>.generate(
      //     10, (index) => 'New Message ${messages.length + index}');
      // messages.insertAll(0, newMessages);

      setState(() {
        isLoading = false;
      });
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