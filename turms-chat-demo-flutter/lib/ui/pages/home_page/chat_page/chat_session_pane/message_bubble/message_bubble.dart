import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../domain/message/message_delivery_status.dart';
import '../../../../../../domain/user/models/user.dart';
import '../../../../../components/t_editor/t_editor.dart';
import '../../../../../themes/theme_config.dart';
import '../../../shared_components/user_profile_popup.dart';
import '../message.dart';
import 'message_bubble_video.dart';

enum _MessageType {
  text,
  file,
  image,
  video,
  audio,
  youtube,
}

final _markdownImageRegex = RegExp(r'!\[(.*?)]\((https?:\/\/\S+\.\w+)\)');

class MessageBubble extends StatefulWidget {
  factory MessageBubble.fromMessage(
      {Key? key,
      required User user,
      required ChatMessage message,
      void Function(BuildContext, Offset)? onLongPress}) {
    final text = message.text;
    if (text.startsWith('![')) {
      final matches = _markdownImageRegex.allMatches(text);
      final matchCount = matches.length;
      if (matchCount == 0 || matchCount > 1) {
        return MessageBubble(
            key: key,
            user: user,
            message: message,
            type: _MessageType.text,
            onLongPress: onLongPress);
      }
      final match = matches.first;
      if (match.groupCount != 2) {
        return MessageBubble(
            key: key,
            user: user,
            message: message,
            type: _MessageType.text,
            onLongPress: onLongPress);
      }
      final url = match.group(2)!;
      if (url.contains('//www.youtube.com/') ||
          url.contains('//youtube.com/')) {
        return MessageBubble(
            key: key,
            user: user,
            message: message,
            type: _MessageType.youtube,
            youtubeUrl: url,
            onLongPress: onLongPress);
      } else if (url.endsWith('.mp4') ||
          url.endsWith('.mov') ||
          url.endsWith('.avi')) {
        return MessageBubble(
            key: key,
            user: user,
            message: message,
            type: _MessageType.video,
            videoUrl: url,
            onLongPress: onLongPress);
      } else if (url.endsWith('.mp3') || url.endsWith('.wav')) {
        return MessageBubble(
            key: key,
            user: user,
            message: message,
            type: _MessageType.audio,
            audioUrl: url,
            onLongPress: onLongPress);
      } else if (url.endsWith('.png') ||
          url.endsWith('.jpg') ||
          url.endsWith('.jpeg') ||
          url.endsWith('.gif')) {
        return MessageBubble(
            key: key,
            user: user,
            message: message,
            type: _MessageType.image,
            imageUrl: url,
            onLongPress: onLongPress);
      } else {
        return MessageBubble(
            key: key,
            user: user,
            message: message,
            type: _MessageType.file,
            fileUrl: url,
            onLongPress: onLongPress);
      }
    } else {
      return MessageBubble(
          key: key,
          user: user,
          message: message,
          type: _MessageType.text,
          onLongPress: onLongPress);
    }
  }

  MessageBubble({
    Key? key,
    required this.user,
    required this.message,
    this.onLongPress,
    required this.type,
    this.fileUrl,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    this.youtubeUrl,
  }) : super(key: key);

  final User user;
  final ChatMessage message;
  final _MessageType type;
  final String? fileUrl;
  final String? imageUrl;
  final String? videoUrl;
  final String? audioUrl;
  final String? youtubeUrl;
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
                  color: Color.fromARGB(255, 250, 81, 81),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Symbols.exclamation_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              )
            else if (message.status == MessageDeliveryStatus.retrying)
              const CupertinoActivityIndicator(),
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

  GestureDetector _buildMessageBubble(BuildContext context) => GestureDetector(
      onLongPressStart: (details) {
        widget.onLongPress?.call(context, details.globalPosition);
      },
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.message.sentByMe
              ? const Color.fromARGB(255, 149, 216, 248)
              : Colors.white,
          borderRadius: ThemeConfig.borderRadius4,
        ),
        child: IntrinsicWidth(
          child: switch (widget.type) {
            _MessageType.text => TEditor(
                controller: _controller,
                contentPadding: ThemeConfig.paddingV4H4,
                readOnly: true,
              ),
            _MessageType.youtube => Text(widget.youtubeUrl ?? ''),
            _MessageType.video => MessageBubbleVideo(
                url: widget.videoUrl!,
              ),
            _MessageType.audio => Text(widget.audioUrl ?? ''),
            _MessageType.image => Text(widget.imageUrl ?? ''),
            _MessageType.file => Text(widget.fileUrl ?? ''),
          },
        ),
      ));
}