import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../domain/message/message_delivery_status.dart';
import '../../../../domain/user/models/user.dart';
import '../../../components/t_editor/t_editor.dart';
import '../../../themes/theme_config.dart';
import '../shared_components/user_profile_popup.dart';
import 'message.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble({
    Key? key,
    required this.user,
    required this.message,
    this.onLongPress,
  }) : super(key: key);

  final User user;
  final ChatMessage message;
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
          child: TEditor(
            controller: _controller,
            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            readOnly: true,
            // onTapOutside: (event) {
            //
            // },
          ),
          // child: QuillEditor.basic(
          //     configurations: QuillEditorConfigurations(
          //   controller: _controller,
          //   customStyles: DefaultStyles.getInstance(context),
          //   onTapOutside: (event, focusNode) {
          //     _controller.updateSelection(
          //         const TextSelection.collapsed(offset: 0), ChangeSource.local);
          //     focusNode.unfocus();
          //   },
          //   showCursor: false,
          //   readOnly: true,
          //   scrollable: false,
          // )),
        ),
      ));
}