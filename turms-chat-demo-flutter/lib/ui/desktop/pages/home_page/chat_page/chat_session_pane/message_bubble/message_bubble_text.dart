import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../../../../domain/user/models/user.dart';
import '../../../../../../themes/index.dart';

import '../../../../../components/index.dart';
import '../message.dart';
import 'message_text_editing_controller.dart';

class MessageBubbleText extends StatefulWidget {
  const MessageBubbleText({
    Key? key,
    required this.currentUser,
    required this.message,
    required this.borderRadius,
  }) : super(key: key);

  final User currentUser;
  final ChatMessage message;
  final BorderRadius borderRadius;

  @override
  State<MessageBubbleText> createState() => _MessageBubbleTextState();
}

const _mentionIconSize = 22.0;

class _MessageBubbleTextState extends State<MessageBubbleText> {
  late MessageTextEditingController _controller;
  late bool _isMentioned;

  @override
  void initState() {
    super.initState();
    final message = widget.message;
    _controller = MessageTextEditingController.fromValue(message.text);
    _isMentioned = !message.sentByMe &&
        (message.mentionAll ||
            message.mentionedUserIds.contains(widget.currentUser.userId));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const color = Color.fromARGB(255, 204, 74, 49);
    Widget content = IntrinsicWidth(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.message.sentByMe
              ? const Color.fromARGB(255, 149, 216, 248)
              : Colors.white,
          borderRadius: widget.borderRadius,
          border: _isMentioned
              ? const Border(
                  left: BorderSide(
                    color: color,
                    width: 4,
                  ),
                )
              : null,
        ),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
          child: Padding(
            padding: Sizes.paddingV8H8,
            child: TEditor(
              controller: _controller,
              contentPadding: Sizes.paddingV4H4,
              readOnly: true,
            ),
          ),
        ),
      ),
    );

    if (_isMentioned) {
      content = Stack(clipBehavior: Clip.none, children: [
        content,
        const Positioned(
          child: SizedBox(
              width: _mentionIconSize,
              height: _mentionIconSize,
              child: DecoratedBox(
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                  child: Icon(
                    Symbols.alternate_email_rounded,
                    color: Colors.white,
                    size: _mentionIconSize - 6,
                  ))),
          top: 0,
          bottom: 0,
          right: -_mentionIconSize / 2,
        )
      ]);
    }
    return content;
  }
}
