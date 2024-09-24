import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../domain/user/models/contact.dart';
import '../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../components/index.dart';
import '../../../../../components/t_switch/t_switch.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../themes/theme_config.dart';

class ChatSessionDetailsGroupConversation extends ConsumerStatefulWidget {
  const ChatSessionDetailsGroupConversation({super.key, required this.contact});

  final GroupContact contact;

  @override
  ConsumerState<ChatSessionDetailsGroupConversation> createState() =>
      _ChatSessionDetailsGroupConversationState();
}

class _ChatSessionDetailsGroupConversationState
    extends ConsumerState<ChatSessionDetailsGroupConversation> {
  bool muteNotifications = false;
  bool stickOnTop = false;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    const divider = THorizontalDivider();
    final intro = widget.contact.intro;
    final members = widget.contact.members;
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SelectionArea(
              child: Text(
            widget.contact.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
        ),
        if (intro.isNotBlank) ...[
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            child: SelectionArea(
              child: Text(
                intro,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: ThemeConfig.textStyleSecondary,
              ),
            ),
          )
        ],
        const SizedBox(
          height: 8,
        ),
        divider,
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(appLocalizations.muteNotifications),
            TSwitch(
              value: muteNotifications,
              onChanged: (value) {
                muteNotifications = value;
                setState(() {});
              },
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(appLocalizations.stickOnTop),
            TSwitch(
              value: stickOnTop,
              onChanged: (value) {
                stickOnTop = value;
                setState(() {});
              },
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        divider,
        const SizedBox(
          height: 8,
        ),
        TTextButton.outlined(
          containerPadding: ThemeConfig.paddingV4H8,
          text: appLocalizations.addNewMember,
          prefix: const Icon(
            Symbols.person_add_rounded,
            size: 20,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TSearchBar(hintText: appLocalizations.search),
        const SizedBox(
          height: 8,
        ),
        Expanded(
            child: ListView.separated(
          // Used to not overlay on the scrollbar
          padding: const EdgeInsets.only(right: 12),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return Row(
              children: [
                TAvatar(name: member.name, size: TAvatarSize.small),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Text(
                  member.name,
                  overflow: TextOverflow.ellipsis,
                )),
                const SizedBox(
                  width: 8,
                ),
                const Icon(Symbols.crowdsource_rounded)
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: 4,
          ),
        )),
        const SizedBox(
          height: 8,
        ),
        divider,
        SizedBox(
          width: double.infinity,
          child: TTextButton(
            containerPadding: const EdgeInsets.symmetric(vertical: 8),
            containerColor: Colors.transparent,
            containerColorHovered: Colors.transparent,
            text: appLocalizations.clearChatHistory,
            textStyle: ThemeConfig.textStyleWarning,
          ),
        ),
        divider,
        SizedBox(
          width: double.infinity,
          child: TTextButton(
            containerPadding: const EdgeInsets.symmetric(vertical: 8),
            containerColor: Colors.transparent,
            containerColorHovered: Colors.transparent,
            text: appLocalizations.leaveGroup,
            textStyle: ThemeConfig.textStyleWarning,
          ),
        )
      ],
    );
  }
}