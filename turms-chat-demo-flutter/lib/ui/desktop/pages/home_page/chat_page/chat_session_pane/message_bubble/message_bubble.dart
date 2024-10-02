import 'package:flutter/cupertino.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../../domain/message/models/message_delivery_status.dart';
import '../../../../../../../domain/message/models/message_type.dart';
import '../../../../../../../domain/user/models/user.dart';
import '../../../../../../themes/theme_config.dart';
import '../../../shared_components/user_profile_popup.dart';
import '../message.dart';
import 'message_bubble_audio.dart';
import 'message_bubble_image.dart';
import 'message_bubble_text.dart';
import 'message_bubble_video.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble({
    Key? key,
    required this.currentUser,
    required this.sender,
    required this.messages,
    this.onLongPress,
  }) : super(key: key);

  final User currentUser;
  final User sender;
  final List<ChatMessage> messages;
  final void Function(BuildContext, Offset)? onLongPress;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: widget.messages.first.sentByMe
          ? _buildSentMessageBubble(context)
          : _buildReceivedMessageBubble(context));

  Row _buildSentMessageBubble(BuildContext context) {
    final messages = widget.messages;
    final messageCount = messages.length;
    assert(messageCount > 0, 'There should be at least one message');
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (messageCount == 1)
          _buildMessage(context, MainAxisAlignment.start, messages.first,
              MessageBubbleTextPosition.single)
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 2,
            children: [
              for (var i = 0; i < messageCount; i++)
                _buildMessage(
                    context,
                    MainAxisAlignment.start,
                    messages[i],
                    i == 0
                        ? MessageBubbleTextPosition.first
                        : i == messageCount - 1
                            ? MessageBubbleTextPosition.last
                            : MessageBubbleTextPosition.middle)
            ],
          ),
        UserProfilePopup(
          user: widget.sender,
          faceLeft: true,
        )
      ],
    );
  }

  Row _buildReceivedMessageBubble(BuildContext context) {
    final messages = widget.messages;
    final messageCount = messages.length;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        UserProfilePopup(user: widget.sender),
        if (messageCount == 1)
          _buildMessage(context, MainAxisAlignment.end, messages.first,
              MessageBubbleTextPosition.single)
        else
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                for (var i = 0; i < messageCount; i++)
                  _buildMessage(
                      context,
                      MainAxisAlignment.end,
                      messages[i],
                      i == 0
                          ? MessageBubbleTextPosition.first
                          : i == messageCount - 1
                              ? MessageBubbleTextPosition.last
                              : MessageBubbleTextPosition.middle),
              ])
      ],
    );
  }

  Row _buildMessage(BuildContext context, MainAxisAlignment mainAxisAlignment,
          ChatMessage message, MessageBubbleTextPosition position) =>
      Row(
        mainAxisAlignment: mainAxisAlignment,
        spacing: 12,
        children: [
          if (message.status == MessageDeliveryStatus.failed)
            const DecoratedBox(
              decoration: BoxDecoration(
                color: ThemeConfig.messageBubbleErrorIconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(1),
                child: Icon(
                  Symbols.exclamation_rounded,
                  color: ThemeConfig.messageBubbleErrorIconColor,
                  size: 20,
                ),
              ),
            )
          else if (message.status == MessageDeliveryStatus.retrying)
            const RepaintBoundary(child: CupertinoActivityIndicator()),
          _buildMessageBubble(context, message, position)
        ],
      );

  Widget _buildMessageBubble(BuildContext context, ChatMessage message,
          MessageBubbleTextPosition position) =>
      GestureDetector(
          onLongPressStart: (details) {
            widget.onLongPress?.call(context, details.globalPosition);
          },
          child: IntrinsicWidth(
            // TODO: we may support compound messages in the future.
            child: switch (message.type) {
              MessageType.text => MessageBubbleText(
                  currentUser: widget.currentUser,
                  message: message,
                  position: position,
                ),
              MessageType.video => MessageBubbleVideo(
                  url: Uri.parse(message.originalUrl!),
                  width: message.originalWidth!,
                  height: message.originalHeight!,
                ),
              MessageType.audio =>
                MessageBubbleAudio(url: Uri.parse(message.originalUrl!)),
              MessageType.image => MessageBubbleImage(
                  url: message.originalUrl!,
                  width: message.originalWidth!,
                  height: message.originalHeight!,
                ),
              MessageType.file => Text(message.originalUrl ?? ''),
              MessageType.youtube => Text(message.originalUrl!),
            },
          ));
}
