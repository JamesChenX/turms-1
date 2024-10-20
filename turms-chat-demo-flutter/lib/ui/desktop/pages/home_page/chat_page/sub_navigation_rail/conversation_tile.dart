import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../../../domain/conversation/models/conversation.dart';
import '../../../../../../domain/message/models/message_type.dart';
import '../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../../l10n/view_models/date_format_view_models.dart';
import '../../../../../themes/index.dart';
import '../../../../components/index.dart';
import '../chat_session_pane/message.dart';

const _messageIconSize = 16.0;

class ConversationTile extends ConsumerStatefulWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.nameTextSpans,
    required this.messageTextSpans,
    required this.isSearchMode,
    this.selected = false,
    this.highlighted = false,
    required this.onTap,
    required this.onSecondaryTap,
  });

  final Conversation conversation;
  final List<TextSpan> nameTextSpans;
  final List<TextSpan> messageTextSpans;
  final bool isSearchMode;

  final bool selected;
  final bool highlighted;

  final GestureTapCallback onTap;
  final GestureTapCallback onSecondaryTap;

  @override
  ConsumerState<ConversationTile> createState() => _ConversationTileState();
}

const _fontWeightBold = FontWeight.w600;

class _ConversationTileState extends ConsumerState<ConversationTile> {
  bool _useBoldText = false;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    final appThemeExtension = context.appThemeExtension;
    _useBoldText =
        !widget.isSearchMode && widget.conversation.unreadMessageCount > 0;
    return TListTile(
      onTap: widget.onTap,
      focused: widget.selected,
      backgroundColor: widget.highlighted
          ? appThemeExtension.conversationBackgroundHighlightedColor
          : appThemeExtension.conversationBackgroundColor,
      padding:
          // use more right padding to reserve space for scrollbar
          // TODO: adapt the padding to not hide part of text (e.g. contact name).
          const EdgeInsets.only(left: 10, right: 14, top: 12, bottom: 12),
      child: Row(mainAxisSize: MainAxisSize.min, spacing: 8, children: [
        _buildAvatar(),
        Expanded(
            child: _buildConversation(
                appThemeExtension, appLocalizations, context))
      ]),
    );
  }

  Stack _buildAvatar() {
    final conversation = widget.conversation;
    return Stack(clipBehavior: Clip.none, children: [
      TAvatar(
        name: conversation.name,
        image: conversation.image,
        // TODO: check presence
        presence: TAvatarUserPresence.values[1 +
            (conversation.contact.hashCode %
                (TAvatarUserPresence.values.length - 1))],
      ),
    ]);
  }

  Column _buildConversation(AppThemeExtension appThemeExtension,
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
                    ? appThemeExtension.conversationTileTimestampTextStyle
                        .copyWith(fontWeight: _fontWeightBold)
                    : appThemeExtension.conversationTileTimestampTextStyle,
                strutStyle:
                    const StrutStyle(fontSize: 14, forceStrutHeight: true),
              )
            ],
          )),
          _buildMessage(draft, appThemeExtension, localizations, lastMessage)
        ]);
  }

  Row _buildMessage(String? draft, AppThemeExtension appThemeExtension,
      AppLocalizations localizations, ChatMessage? lastMessage) {
    final children = draft?.isNotBlank ?? false
        ? [
            // Note: the draft is always a text instead of image, video, or etc as
            // we haven't supported embedded images, videos, and etc, into a message.
            TextSpan(
                text: '[${localizations.draft}]',
                style: _useBoldText
                    ? appThemeExtension.highlightTextStyle
                        .copyWith(fontWeight: _fontWeightBold)
                    : appThemeExtension.highlightTextStyle),
            TextSpan(text: draft),
          ]
        : lastMessage != null
            ? switch (lastMessage.type) {
                MessageType.text => [TextSpan(text: lastMessage.text)],
                MessageType.image => [
                    const WidgetSpan(
                        child: Icon(Symbols.image_rounded,
                            size: _messageIconSize)),
                    TextSpan(
                      text: localizations.image,
                    )
                  ],
                MessageType.file => [
                    const WidgetSpan(
                        child: Icon(Symbols.description_rounded,
                            size: _messageIconSize)),
                    TextSpan(
                      text: localizations.file,
                    )
                  ],
                MessageType.video => [
                    const WidgetSpan(
                        child: Icon(Symbols.video_file_rounded,
                            size: _messageIconSize)),
                    TextSpan(
                      text: localizations.video,
                    )
                  ],
                MessageType.audio => [
                    const WidgetSpan(
                        child: Icon(Symbols.audio_file_rounded,
                            size: _messageIconSize)),
                    TextSpan(
                      text: localizations.audio,
                    )
                  ],
                MessageType.youtube => [
                    const WidgetSpan(
                        child: Icon(Symbols.smart_display_rounded,
                            size: _messageIconSize)),
                    TextSpan(
                      text: localizations.youtube,
                    )
                  ],
              }
            : <TextSpan>[];
    final strutStyle = StrutStyle(
        fontSize: appThemeExtension.conversationTileMessageTextStyle.fontSize!,
        forceStrutHeight: true);
    return Row(
      children: [
        Flexible(
          child: widget.isSearchMode
              ? Text.rich(
                  TextSpan(children: widget.messageTextSpans),
                  style: appThemeExtension.conversationTileMessageTextStyle,
                  strutStyle: strutStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                )
              : Text.rich(
                  TextSpan(children: children),
                  style: _useBoldText
                      ? appThemeExtension.conversationTileMessageTextStyle
                          .copyWith(fontWeight: _fontWeightBold)
                      : appThemeExtension.conversationTileMessageTextStyle,
                  strutStyle: strutStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
        ),
      ],
    );
  }
}
