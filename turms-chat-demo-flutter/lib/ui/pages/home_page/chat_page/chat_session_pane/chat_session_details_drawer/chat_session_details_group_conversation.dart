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
                // TODO: test
                intro.padRight(200, '123test'),
                maxLines: 4,
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
        Row(
          children: [
            Text(appLocalizations.stickOnTop),
            TSwitch(
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        divider,
        const SizedBox(
          height: 8,
        ),
        TTextButton(
          text: appLocalizations.addNewMember,
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
          itemCount: 20,
          itemBuilder: (context, index) => Row(
            children: [
              TAvatar(name: 'name', size: TAvatarSize.small),
              const SizedBox(
                width: 8,
              ),
              const Expanded(
                  child: Text(
                'a very long name, a very long name, a very long name, a very long name',
                overflow: TextOverflow.ellipsis,
              )),
              const SizedBox(
                width: 8,
              ),
              const Icon(Symbols.crowdsource_rounded)
            ],
          ),
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: 4,
          ),
        )),
        const SizedBox(
          height: 8,
        ),
        TTextButton(
          text: appLocalizations.leaveGroup,
        )
      ],
    );
  }
}
