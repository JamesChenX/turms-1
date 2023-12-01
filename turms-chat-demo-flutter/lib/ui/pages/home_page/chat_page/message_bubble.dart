import 'package:flutter/material.dart';

import '../../../components/components.dart';

class MessageBubble extends StatefulWidget {
  final bool isMyMessage;
  final String message;
  final void Function(BuildContext, Offset)? onLongPress;

  const MessageBubble({
    Key? key,
    required this.isMyMessage,
    required this.message,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  late QuillController _controller;

  // @override
  // void didUpdateWidget(MessageBubble oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void initState() {
    super.initState();
    final doc = Document()..insert(0, widget.message);
    _controller = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageBubble = GestureDetector(
        onLongPressStart: (details) {
          widget.onLongPress?.call(context, details.globalPosition);
        },
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.isMyMessage
                ? Color.fromARGB(255, 149, 216, 248)
                : Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: QuillProvider(
            configurations: QuillConfigurations(controller: _controller),
            child: IntrinsicWidth(
              child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                customStyles: DefaultStyles.getInstance(context),
                // controller: _controller,
                showCursor: false,
                readOnly: true,
                scrollable: false,
                placeholder: 'Write your notes',
              )),
            ),
          ),
        ));
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: widget.isMyMessage
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  messageBubble,
                  SizedBox(
                    width: 8,
                  ),
                  TAvatar()
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TAvatar(),
                  SizedBox(
                    width: 8,
                  ),
                  messageBubble
                ],
              ));
  }
}