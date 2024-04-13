import 'package:flutter/material.dart';

import '../../../../../components/t_editor/t_editor.dart';
import '../../../../../themes/theme_config.dart';
import '../message.dart';

class MessageBubbleText extends StatefulWidget {
  const MessageBubbleText({Key? key, required this.message}) : super(key: key);

  final ChatMessage message;

  @override
  State<MessageBubbleText> createState() => _MessageBubbleTextState();
}

class _MessageBubbleTextState extends State<MessageBubbleText> {
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
  Widget build(BuildContext context) => IntrinsicWidth(
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
          child: TEditor(
            controller: _controller,
            contentPadding: ThemeConfig.paddingV4H4,
            readOnly: true,
          ),
        ),
      );
}
