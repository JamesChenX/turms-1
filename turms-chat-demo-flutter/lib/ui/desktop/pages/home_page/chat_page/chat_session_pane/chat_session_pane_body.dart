import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/conversation/models/conversation.dart';
import '../../../../../../domain/message/models/message_group.dart';
import '../../../../../../domain/message/models/message_type.dart';
import '../../../../../../domain/user/fixtures/contacts.dart';
import '../../../../../../domain/user/models/user.dart';
import '../../../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../../l10n/view_models/date_format_view_models.dart';
import '../../../../../themes/theme_config.dart';
import 'message.dart';
import 'message_bubble/message_bubble.dart';

class ChatSessionPaneBody extends ConsumerStatefulWidget {
  const ChatSessionPaneBody(this.selectedConversation, {super.key});

  final Conversation selectedConversation;

  @override
  ConsumerState<ChatSessionPaneBody> createState() =>
      _ChatSessionPaneBodyState();
}

const _chatSessionItemLoadingIndicatorId = Int64.MIN_VALUE;
const _chatSessionItemLoadingIndicatorKey =
    ValueKey(_chatSessionItemLoadingIndicatorId);

class _ChatSessionPaneBodyState extends ConsumerState<ChatSessionPaneBody> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final position = _scrollController.position;
      final pixels = position.pixels;
      if (pixels + 8 >= position.maxScrollExtent) {
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

  /// We don't use sealed classes to limit possible values for better performance (don't need to create new objects).
  List<_ChatSessionItem> _generateItems(List<ChatMessage> messages) {
    final items = <_ChatSessionItem>[_ChatSessionItemLoadingIndicator()];
    final messageCount = messages.length;
    if (messageCount == 0) {
      return items;
    }
    ChatMessage? lastMessage;
    MessageGroup? lastMessageGroup;
    assert(() {
      final sortedMessages = List<ChatMessage>.from(messages)
        ..sort(
          (a, b) {
            final result = a.timestamp.compareTo(b.timestamp);
            if (result == 0) {
              // Used to ensure a stable sort.
              return a.messageId.compareTo(b.messageId);
            }
            return result;
          },
        );
      return const ListEquality<ChatMessage>().equals(sortedMessages, messages);
    }(),
        "The messages should have been sorted by date so that we don't need to sort them again and again when building the list");
    final lastMessageIndex = messageCount - 1;
    for (var i = 0; i < messageCount; i++) {
      final message = messages[i];
      final timestamp = message.timestamp;
      if (lastMessage == null) {
        items.add(_ChatSessionItemDaySeparator(timestamp));
      } else {
        final lastMessageTimestamp = lastMessage.timestamp;
        assert(
            lastMessageTimestamp.timeZoneName ==
                lastMessageTimestamp.timeZoneName,
            'The timestamp of messages should have the same time zone name');
        if (DateUtils.isSameDay(lastMessageTimestamp, timestamp)) {
          if (lastMessage.type == MessageType.text &&
              message.type == MessageType.text &&
              lastMessage.senderId == message.senderId &&
              lastMessageTimestamp.hour == timestamp.hour &&
              lastMessageTimestamp.minute == timestamp.minute) {
            if (lastMessageGroup == null) {
              lastMessageGroup = MessageGroup([lastMessage, message]);
              items.add(_ChatSessionItemMessageGroup(lastMessageGroup));
            } else {
              lastMessageGroup.addMessage(message);
            }
            if (i == lastMessageIndex) {
              return items;
            }
          } else {
            if (lastMessageGroup == null ||
                lastMessage.messageId !=
                    lastMessageGroup.messages.last.messageId) {
              items.add(_ChatSessionItemMessage(lastMessage));
            }
            lastMessageGroup = null;
          }
        } else {
          lastMessageGroup = null;
          if (lastMessageGroup != null &&
              lastMessage.messageId ==
                  lastMessageGroup.messages.last.messageId) {
            items.add(_ChatSessionItemMessage(lastMessage));
          }
          items.add(_ChatSessionItemDaySeparator(timestamp));
        }
      }
      if (i == lastMessageIndex) {
        if (lastMessageGroup == null ||
            lastMessage == null ||
            lastMessage.messageId != lastMessageGroup.messages.last.messageId) {
          items.add(_ChatSessionItemMessage(message));
        }
        return items;
      } else {
        lastMessage = message;
      }
    }
    throw AssertionError('Unreachable code reached');
  }

  ListView _buildMessageBubbles(Conversation conversation) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    final loggedInUser = ref.watch(loggedInUserViewModel)!;
    final dateFormat = ref.watch(dateFormatViewModel_yMd);
    final items = _generateItems(conversation.messages);
    final itemCount = items.length;
    final itemIdToIndex = {
      for (var i = 0; i < itemCount; i++) items[i].id: itemCount - i - 1
    };
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      controller: _scrollController,
      // Reverse the list to display conversations from bottom to top
      reverse: true,
      itemCount: itemCount,
      findChildIndexCallback: (key) {
        final id = (key as ValueKey<Int64>).value;
        return itemIdToIndex[id];
      },
      itemBuilder: (context, index) {
        // Calculate the actual index in the conversations list.
        // [index] starts from 0,
        // we return the last item in [items] for the index 0.
        final actualIndex = itemCount - index - 1;
        final item = items[actualIndex];
        switch (item) {
          case _ChatSessionItemLoadingIndicator():
            if (isLoading) {
              return const Padding(
                key: _chatSessionItemLoadingIndicatorKey,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: CupertinoActivityIndicator(radius: 8),
              );
            } else {
              return const Center(
                key: _chatSessionItemLoadingIndicatorKey,
                child: Text('Load More Messages'),
              );
            }
          case _ChatSessionItemDaySeparator(:final datetime):
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: DecoratedBox(
                  key: ValueKey(item.id),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 218, 218, 218),
                      borderRadius: ThemeConfig.borderRadius4),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: Text(
                      DateUtils.isSameDay(yesterday, datetime)
                          ? appLocalizations.yesterday
                          : dateFormat.format(datetime),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            );
          case _ChatSessionItemMessageGroup(:final messageGroup):
            final User user;
            final message = messageGroup.messages.first;
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
              key: ValueKey(item.id),
              currentUser: loggedInUser,
              sender: user,
              messages: messageGroup.messages,
            );
          case _ChatSessionItemMessage(:final message):
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
              key: ValueKey(item.id),
              currentUser: loggedInUser,
              sender: user,
              messages: [message],
            );
        }
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
    Future<void>.delayed(const Duration(seconds: 2), () {
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

sealed class _ChatSessionItem {
  const _ChatSessionItem(this.id);

  final Int64 id;
}

class _ChatSessionItemLoadingIndicator extends _ChatSessionItem {
  _ChatSessionItemLoadingIndicator()
      : super(_chatSessionItemLoadingIndicatorId);
}

class _ChatSessionItemDaySeparator extends _ChatSessionItem {
  _ChatSessionItemDaySeparator(this.datetime)
      : super(Int64(-datetime.millisecondsSinceEpoch));

  final DateTime datetime;
}

class _ChatSessionItemMessage extends _ChatSessionItem {
  _ChatSessionItemMessage(this.message) : super(message.messageId);

  final ChatMessage message;
}

class _ChatSessionItemMessageGroup extends _ChatSessionItem {
  _ChatSessionItemMessageGroup(this.messageGroup)
      : super((-messageGroup.messages.first.messageId) | (Int64(1) << 62));

  final MessageGroup messageGroup;
}
