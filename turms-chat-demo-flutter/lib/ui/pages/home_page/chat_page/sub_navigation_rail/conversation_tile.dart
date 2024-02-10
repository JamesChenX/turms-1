import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turms_chat_demo/ui/pages/home_page/chat_page/message.dart';

import '../../../../../domain/conversation/models/conversation.dart';
import '../../../../components/t_avatar/t_avatar.dart';
import '../../../../components/t_list_tile.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../l10n/view_models/date_format_view_models.dart';
import '../../../../themes/theme_config.dart';

const diameter = 10.0;
const rightOffset = -diameter / 2;
const topOffset = -diameter / 2;

class ConversationTile extends ConsumerStatefulWidget {
  const ConversationTile(
      {super.key,
      required this.conversation,
      this.focused = false,
      required this.onTap});

  final Conversation conversation;
  final bool focused;

  final GestureTapCallback onTap;

  @override
  ConsumerState<ConversationTile> createState() => _ConversationTileState();
}

class _ConversationTileState extends ConsumerState<ConversationTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    final conversation = widget.conversation;
    return TListTile(
      onTap: widget.onTap,
      focused: widget.focused,
      backgroundColor: ThemeConfig.conversationBackgroundColor,
      focusedBackgroundColor: ThemeConfig.conversationFocusedBackgroundColor,
      hoveredBackgroundColor: ThemeConfig.conversationHoveredBackgroundColor,
      padding:
          // use more right padding to reserve space for scrollbar
          // TODO: adpat the padding to not hide part of text (e.g. contact name).
          const EdgeInsets.only(left: 10, right: 14, top: 12, bottom: 12),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _buildAvatar(conversation),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: _buildConversation(appLocalizations, context))
      ]),
    );
  }

  Stack _buildAvatar(Conversation conversation) =>
      Stack(clipBehavior: Clip.none, children: [
        TAvatar(
          name: conversation.name,
          image: conversation.image,
        ),
        if (conversation.unreadMessageCount > 0)
          Positioned(
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                  width: diameter, height: diameter),
              child: const DecoratedBox(
                decoration:
                    BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              ),
            ),
            right: rightOffset,
            top: topOffset,
          )
      ]);

  Column _buildConversation(
      AppLocalizations localizations, BuildContext context) {
    final dateFormat = ref.watch(dateFormatViewModel_jm);
    final conversation = widget.conversation;
    final draft = conversation.draft;
    final messages = conversation.messages;
    final lastMessage = messages.lastOrNull;
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(
                conversation.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              )),
              const SizedBox(
                width: 12,
              ),
              Text(
                lastMessage == null
                    ? ''
                    : dateFormat.format(lastMessage.timestamp),
                style: const TextStyle(color: ThemeConfig.gray7, fontSize: 14),
                strutStyle:
                    const StrutStyle(fontSize: 14, forceStrutHeight: true),
              )
            ],
          )),
          _buildMessage(draft, localizations, lastMessage)
        ]);
  }

  Row _buildMessage(String? draft, AppLocalizations localizations,
          ChatMessage? lastMessage) =>
      Row(
        children: [
          if (draft != null)
            // todo: textspan
            Text(
              '[${localizations.draft}]',
              style: const TextStyle(color: ThemeConfig.gray7, fontSize: 14),
              strutStyle:
                  const StrutStyle(fontSize: 14, forceStrutHeight: true),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          Flexible(
              child: Text(
            draft ?? lastMessage?.text ?? '',
            style: const TextStyle(color: ThemeConfig.gray7, fontSize: 14),
            strutStyle: const StrutStyle(fontSize: 14, forceStrutHeight: true),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ))
        ],
      );
}