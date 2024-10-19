import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../../domain/message/models/message_delivery_status.dart';
import '../../../../../../../domain/message/models/message_type.dart';
import '../../../../../../../domain/user/models/user.dart';
import '../../../../../../l10n/view_models/date_format_view_models.dart';
import '../../../../../../themes/index.dart';
import '../../../../../components/index.dart';
import '../../../shared_components/user_profile_popup.dart';
import '../message.dart';
import 'message_bubble_audio.dart';
import 'message_bubble_image.dart';
import 'message_bubble_text.dart';
import 'message_bubble_video.dart';

class MessageBubble extends ConsumerStatefulWidget {
  const MessageBubble({
    Key? key,
    required this.currentUser,
    required this.sender,
    required this.messages,
    this.onRetry,
  }) : super(key: key);

  final User currentUser;
  final User sender;
  final List<ChatMessage> messages;
  final Future<void> Function()? onRetry;

  @override
  ConsumerState<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<MessageBubble> {
  late DateTime _now;

  @override
  Widget build(BuildContext context) {
    _now = DateTime.now();
    return Padding(
        padding: Sizes.paddingV4H8,
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
              CrossAxisAlignment.end, Sizes.borderRadiusCircular4)
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
          popupAnchor: Alignment.topRight,
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
              CrossAxisAlignment.start, Sizes.borderRadiusCircular4)
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

  Widget _buildMessage(
      BuildContext context,
      MainAxisAlignment mainAxisAlignment,
      ChatMessage message,
      CrossAxisAlignment? infoAlignment,
      BorderRadius borderRadius) {
    final deliveryStatus = message.status;
    final appThemeExtension = context.appThemeExtension;

    final content = Row(
      mainAxisAlignment: mainAxisAlignment,
      spacing: 12,
      children: [
        if (deliveryStatus == MessageDeliveryStatus.failed)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                await widget.onRetry!();
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      appThemeExtension.messageBubbleErrorIconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Icon(
                    Symbols.exclamation_rounded,
                    color: appThemeExtension.messageBubbleErrorIconColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        else if (deliveryStatus == MessageDeliveryStatus.delivering)
          const RepaintBoundary(child: CupertinoActivityIndicator()),
        IntrinsicWidth(
          // TODO: we may support compound messages in the future.
          child: switch (message.type) {
            MessageType.text => TSelectionContainer(
                visible: true,
                child: MessageBubbleText(
                  currentUser: widget.currentUser,
                  message: message,
                  borderRadius: borderRadius,
                ),
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
        ),
      ],
    );
    if (infoAlignment == null) {
      return content;
    }
    final sender = widget.sender;
    return Column(
      crossAxisAlignment: infoAlignment,
      spacing: 4,
      children: [
        Row(
          spacing: 8,
          children: [
            if (sender.userId != widget.currentUser.userId)
              if (message.isGroupMessage)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // TODO
                      // widget.mentionUser(message.senderId);
                    },
                    child: Text(sender.name,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                )
              else
                Text(sender.name,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
            Text(_formatMessageTimestamp(widget.messages.first.timestamp),
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        content,
      ],
    );
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