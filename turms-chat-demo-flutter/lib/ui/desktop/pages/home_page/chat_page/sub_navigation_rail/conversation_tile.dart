import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../../../domain/conversation/models/conversation.dart';
import '../../../../../../domain/message/models/message_type.dart';
import '../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../../l10n/view_models/date_format_view_models.dart';
import '../../../../../themes/theme_config.dart';
import '../../../../components/index.dart';
import '../chat_session_pane/message.dart';

const diameter = 12.0;

class ConversationTile extends ConsumerStatefulWidget {
  const ConversationTile(
      {super.key,
      required this.conversation,
      required this.nameTextSpans,
      required this.messageTextSpans,
      required this.isSearchMode,
      this.selected = false,
      this.highlighted = false,
      required this.onTap});

  final Conversation conversation;
  final List<TextSpan> nameTextSpans;
  final List<TextSpan> messageTextSpans;
  final bool isSearchMode;

  final bool selected;
  final bool highlighted;

  final GestureTapCallback onTap;

  @override
  ConsumerState<ConversationTile> createState() => _ConversationTileState();
}

const _fontWeightBold = FontWeight.w600;

class _ConversationTileState extends ConsumerState<ConversationTile> {
  bool _useBoldText = false;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    _useBoldText =
        !widget.isSearchMode && widget.conversation.unreadMessageCount > 0;
    return TListTile(
      onTap: widget.onTap,
      focused: widget.selected,
      backgroundColor: widget.highlighted
          ? ThemeConfig.conversationBackgroundColorHighlighted
          : ThemeConfig.conversationBackgroundColor,
      padding:
          // use more right padding to reserve space for scrollbar
          // TODO: adapt the padding to not hide part of text (e.g. contact name).
          const EdgeInsets.only(left: 10, right: 14, top: 12, bottom: 12),
      child: Row(mainAxisSize: MainAxisSize.min, spacing: 8, children: [
        _buildAvatar(),
        Expanded(child: _buildConversation(appLocalizations, context))
      ]),
    );
  }

  Stack _buildAvatar() {
    final conversation = widget.conversation;
    return Stack(clipBehavior: Clip.none, children: [
      TAvatar(
        name: conversation.name,
        image: conversation.image,
      ),
      _buildPresence()
    ]);
  }

  // TODO: check presence
  Positioned _buildPresence() => const Positioned(
        child: SizedBox(
          width: diameter + 2,
          height: diameter + 2,
          child: DecoratedBox(
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Center(
              child: SizedBox(
                width: diameter,
                height: diameter,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 107, 183, 0),
                      shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        ),
        right: 0,
        bottom: 0,
      );

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
            spacing: 12,
            children: [
              Flexible(
                  child: Text.rich(
                TextSpan(children: widget.nameTextSpans),
                style: _useBoldText
                    ? const TextStyle(fontWeight: _fontWeightBold)
                    : null,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              )),
              Text(
                lastMessage == null || widget.isSearchMode
                    ? ''
                    : dateFormat.format(lastMessage.timestamp),
                style: _useBoldText
                    ? const TextStyle(
                        color: ThemeConfig.gray7,
                        fontSize: 14,
                        fontWeight: _fontWeightBold)
                    : const TextStyle(color: ThemeConfig.gray7, fontSize: 14),
                strutStyle:
                    const StrutStyle(fontSize: 14, forceStrutHeight: true),
              )
            ],
          )),
          _buildMessage(draft, localizations, lastMessage)
        ]);
  }

  Row _buildMessage(
      String? draft, AppLocalizations localizations, ChatMessage? lastMessage) {
    final children = draft?.isNotBlank ?? false
        ? [
            // Note: the draft is always a text instead of image, video, or etc as
            // we haven't supported embedded images, videos, and etc, into a message.
            TextSpan(
                text: '[${localizations.draft}]',
                style: _useBoldText
                    ? ThemeConfig.textStyleHighlight
                        .copyWith(fontWeight: _fontWeightBold)
                    : ThemeConfig.textStyleHighlight),
            TextSpan(text: draft),
          ]
        : lastMessage != null
            ? switch (lastMessage.type) {
                MessageType.text => [TextSpan(text: lastMessage.text)],
                MessageType.image => [
                    const WidgetSpan(child: Icon(Symbols.image_rounded)),
                    TextSpan(
                      text: localizations.image,
                    )
                  ],
                MessageType.file => [
                    const WidgetSpan(child: Icon(Symbols.description_rounded)),
                    TextSpan(
                      text: localizations.file,
                    )
                  ],
                MessageType.video => [
                    const WidgetSpan(child: Icon(Symbols.video_file_rounded)),
                    TextSpan(
                      text: localizations.video,
                    )
                  ],
                MessageType.audio => [
                    const WidgetSpan(child: Icon(Symbols.audio_file_rounded)),
                    TextSpan(
                      text: localizations.audio,
                    )
                  ],
                MessageType.youtube => [
                    const WidgetSpan(
                        child: Icon(Symbols.smart_display_rounded)),
                    TextSpan(
                      text: localizations.youtube,
                    )
                  ],
              }
            : <TextSpan>[];
    return Row(
      children: [
        Flexible(
          child: widget.isSearchMode
              ? Text.rich(
                  TextSpan(children: widget.messageTextSpans),
                  style:
                      const TextStyle(color: ThemeConfig.gray7, fontSize: 14),
                  strutStyle:
                      const StrutStyle(fontSize: 14, forceStrutHeight: true),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                )
              : Text.rich(
                  TextSpan(children: children),
                  style: _useBoldText
                      ? const TextStyle(
                          color: ThemeConfig.gray7,
                          fontSize: 14,
                          fontWeight: _fontWeightBold)
                      : const TextStyle(
                          color: ThemeConfig.gray7,
                          fontSize: 14,
                        ),
                  strutStyle:
                      const StrutStyle(fontSize: 14, forceStrutHeight: true),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
        ),
      ],
    );
  }
}
