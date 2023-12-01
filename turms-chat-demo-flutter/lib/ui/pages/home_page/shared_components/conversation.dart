import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';

import '../../../components/t_avatar.dart';
import '../../../themes/theme_config.dart';
import '../chat_page/message.dart';

class Conversation extends StatefulWidget {
  const Conversation(
      {super.key,
      required this.conversation,
      required this.backgroundColor,
      required this.hoverBackgroundColor,
      required this.onTap});

  final ConversationData conversation;
  final Color backgroundColor;
  final Color hoverBackgroundColor;
  final GestureTapCallback onTap;

  @override
  State<StatefulWidget> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
            height: 40 + 24,
            // constraints: BoxConstraints(),
            alignment: Alignment.center,
            color: isHovered
                ? widget.hoverBackgroundColor
                : widget.backgroundColor,
            padding:
                // use more right padding to reserve space for scrollbar
                const EdgeInsets.only(left: 10, right: 14, top: 12, bottom: 12),
            duration: const Duration(milliseconds: 100),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const TAvatar(),
              const SizedBox(
                width: 10,
              ),
              Expanded(child: _buildConversation())
            ])),
      ));

  Column _buildConversation() {
    final conversation = widget.conversation;
    final draft = conversation.draft;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                conversation.contactName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              )),
              const SizedBox(
                width: 12,
              ),
              const Text(
                '12:40 PM',
                style: TextStyle(color: ThemeConfig.gray7, fontSize: 13),
              )
            ],
          )),
          Row(
            children: [
              if (draft != null)
                Text(
                  '[Draft]',
                  style: TextStyle(color: ThemeConfig.gray7, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              Expanded(
                  child: Text(
                draft == null
                    ? (conversation.messages.firstOrNull?.text ?? '')
                    : draft,
                style: TextStyle(color: ThemeConfig.gray7, fontSize: 13),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ))
            ],
          )
        ]);
  }
}

class ConversationData {
  ConversationData(
      {required this.isGroupConversation,
      required this.fromId,
      required this.contactName,
      required this.messages,
      this.unreadMessageCount = 0,
      this.draft});

  final bool isGroupConversation;
  final Int64 fromId;
  final String contactName;
  final List<ChatMessage> messages;
  int unreadMessageCount;
  String? draft;

  String get id => '${isGroupConversation ? '1' : '0'}${fromId.toString()}';
}