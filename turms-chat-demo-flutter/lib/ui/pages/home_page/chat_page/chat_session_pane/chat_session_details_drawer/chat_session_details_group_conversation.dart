import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../domain/user/models/contact.dart';
import '../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../components/index.dart';
import '../../../../../components/t_switch/t_switch.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../themes/theme_config.dart';

class ChatSessionDetailsGroupConversation extends ConsumerWidget {
  const ChatSessionDetailsGroupConversation({super.key, required this.contact});

  final GroupContact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = AppLocalizations.of(context);
    const divider = THorizontalDivider();
    final intro = contact.intro;
    final members = contact.members;
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SelectionArea(
              child: Text(
            contact.name,
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
              value: false,
              onChanged: (value) {},
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
              value: false,
              onChanged: (value) {},
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
          prefix: Icon(
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
          padding: EdgeInsets.only(right: 12),
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
            containerPadding: EdgeInsets.symmetric(vertical: 8),
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
            containerPadding: EdgeInsets.symmetric(vertical: 8),
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
