import 'package:flutter/cupertino.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../../domain/message/models/message_delivery_status.dart';
import '../../../../../../../domain/message/models/message_type.dart';
import '../../../../../../../domain/user/models/user.dart';
import '../../../../../../themes/theme_config.dart';
import '../../../shared_components/user_profile_popup.dart';
import '../message.dart';
import 'message_bubble_image.dart';
import 'message_bubble_text.dart';
import 'message_bubble_video.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble({
    Key? key,
    required this.user,
    required this.message,
    this.onLongPress,
    required this.type,
    this.originalUrl,
    this.thumbnailUrl,
  }) : super(key: key);

  final User user;
  final ChatMessage message;
  final MessageType type;
  final String? originalUrl;
  final String? thumbnailUrl;
  final void Function(BuildContext, Offset)? onLongPress;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final message = widget.message;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: message.sentByMe
            ? _buildSentMessageBubble(user, message, context)
            : _buildReceivedMessageBubble(user, context));
  }

  Row _buildSentMessageBubble(
          User user, ChatMessage message, BuildContext context) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
              const SizedBox(
                width: 12,
              ),
              _buildMessageBubble(context)
            ],
          ),
          const SizedBox(
            width: 8,
          ),
          UserProfilePopup(
            user: user,
            faceLeft: true,
          )
        ],
      );

  Row _buildReceivedMessageBubble(User user, BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TAvatar(name: user.name, image: user.image),
          UserProfilePopup(user: user),
          const SizedBox(
            width: 8,
          ),
          _buildMessageBubble(context)
        ],
      );

  Widget _buildMessageBubble(BuildContext context) => GestureDetector(
      onLongPressStart: (details) {
        widget.onLongPress?.call(context, details.globalPosition);
      },
      child: IntrinsicWidth(
        child: switch (widget.type) {
          MessageType.text => MessageBubbleText(
              message: widget.message,
            ),
          MessageType.youtube => Text(widget.originalUrl! ?? ''),
          MessageType.video => MessageBubbleVideo(
              url: Uri.parse(widget.originalUrl!),
            ),
          MessageType.audio => Text(widget.originalUrl ?? ''),
          MessageType.image => MessageBubbleImage(url: widget.originalUrl!),
          MessageType.file => Text(widget.originalUrl ?? ''),
        },
      ));
}