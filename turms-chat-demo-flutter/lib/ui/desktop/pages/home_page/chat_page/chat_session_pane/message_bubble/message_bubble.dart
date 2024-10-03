import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../../domain/message/models/message_delivery_status.dart';
import '../../../../../../../domain/message/models/message_type.dart';
import '../../../../../../../domain/user/models/user.dart';
import '../../../../../../l10n/view_models/date_format_view_models.dart';
import '../../../../../../themes/theme_config.dart';
import '../../../shared_components/user_profile_popup.dart';
import '../message.dart';
import 'message_bubble_audio.dart';
import 'message_bubble_image.dart';
import 'message_bubble_text.dart';
import 'message_bubble_video.dart';

class MessageBubble extends ConsumerStatefulWidget {
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
  ConsumerState<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<MessageBubble> {
  late DateTime _now;

  @override
  Widget build(BuildContext context) {
    _now = DateTime.now();
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: widget.messages.first.sentByMe
            ? _buildSentMessageBubble(context)
            : _buildReceivedMessageBubble(context));
  }

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
              CrossAxisAlignment.end, ThemeConfig.borderRadius4)
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
                    i == 0 ? CrossAxisAlignment.end : null,
                    i == 0
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                            bottomLeft: Radius.circular(4))
                        : i == messageCount - 1
                            ? const BorderRadius.only(
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                                topLeft: Radius.circular(4),
                              )
                            : const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              ))
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
              CrossAxisAlignment.start, ThemeConfig.borderRadius4)
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
                      i == 0 ? CrossAxisAlignment.start : null,
                      i == 0
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4))
                          : i == messageCount - 1
                              ? const BorderRadius.only(
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                )
                              : const BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ))
              ])
      ],
    );
  }

  Row _buildMessage(
          BuildContext context,
          MainAxisAlignment mainAxisAlignment,
          ChatMessage message,
          CrossAxisAlignment? infoAlignment,
          BorderRadius borderRadius) =>
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
          _buildMessageBubble(context, message, infoAlignment, borderRadius)
        ],
      );

  Widget _buildMessageBubble(BuildContext context, ChatMessage message,
      CrossAxisAlignment? infoAlignment, BorderRadius borderRadius) {
    final child = GestureDetector(
        onLongPressStart: (details) {
          widget.onLongPress?.call(context, details.globalPosition);
        },
        child: IntrinsicWidth(
          // TODO: we may support compound messages in the future.
          child: switch (message.type) {
            MessageType.text => MessageBubbleText(
                currentUser: widget.currentUser,
                message: message,
                borderRadius: borderRadius,
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
    if (infoAlignment != null) {
      final sender = widget.sender;
      return Column(
        crossAxisAlignment: infoAlignment,
        spacing: 4,
        children: [
          Row(
            spacing: 8,
            children: [
              if (sender.userId != widget.currentUser.userId)
                Text(sender.name,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
              Text(_formatMessageTimestamp(widget.messages.first.timestamp),
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
          child,
        ],
      );
    }
    return child;
  }

  String _formatMessageTimestamp(DateTime timestamp) {
    if (_now.year != timestamp.year) {
      return ref.watch(dateFormatViewModel_yMdjms).format(timestamp);
    } else if (_now.month != timestamp.month || _now.day != timestamp.day) {
      return ref.watch(dateFormatViewModel_Mdjms).format(timestamp);
    } else {
      return ref.watch(dateFormatViewModel_jm).format(timestamp);
    }
  }
}
