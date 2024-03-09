import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../domain/message/models/message_delivery_status.dart';
import '../../../../../../domain/message/models/message_text_info.dart';
import '../../../../../../domain/message/models/message_type.dart';
import '../../../../../../domain/user/models/user.dart';
import '../../../../../components/t_editor/t_editor.dart';
import '../../../../../themes/theme_config.dart';
import '../../../shared_components/user_profile_popup.dart';
import '../message.dart';
import 'message_bubble_image.dart';
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
  late EmojiTextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EmojiTextEditingController(text: widget.message.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final message = widget.message;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: message.sentByMe
            ? _buildMyMessageBubble(user, message, context)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TAvatar(name: user.name, image: user.image),
                  UserProfilePopup(user: user),
                  const SizedBox(
                    width: 8,
                  ),
                  _buildMessageBubble(context)
                ],
              ));
  }

  Row _buildMyMessageBubble(
      User user, ChatMessage message, BuildContext context) {
    final messageBubble = _buildMessageBubble(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (message.status == MessageDeliveryStatus.failed)
              Container(
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  color: ThemeConfig.messageBubbleErrorIconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Symbols.exclamation_rounded,
                  color: ThemeConfig.messageBubbleErrorIconColor,
                  size: 20,
                ),
              )
            else if (message.status == MessageDeliveryStatus.retrying)
              RepaintBoundary(child: const CupertinoActivityIndicator()),
            const SizedBox(
              width: 12,
            ),
            messageBubble
          ],
        ),
        const SizedBox(
          width: 8,
        ),
        UserProfilePopup(
          user: user,
          position: UserProfilePopupPosition.bottomLeft,
        )
      ],
    );
  }

  Widget _buildMessageBubble(BuildContext context) => GestureDetector(
      onLongPressStart: (details) {
        widget.onLongPress?.call(context, details.globalPosition);
      },
      child: IntrinsicWidth(
        child: switch (widget.type) {
          MessageType.text => Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.message.sentByMe
                    ? const Color.fromARGB(255, 149, 216, 248)
                    : Colors.white,
                borderRadius: ThemeConfig.borderRadius4,
              ),
              child: TEditor(
                controller: _controller,
                contentPadding: ThemeConfig.paddingV4H4,
                readOnly: true,
              ),
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
