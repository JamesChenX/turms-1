import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/user/models/contact.dart';
import '../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../components/t_button/t_text_button.dart';
import '../../../../../components/t_divider/t_horizontal_divider.dart';
import '../../../../../components/t_switch/t_switch.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../themes/theme_config.dart';

class ChatSessionDetailsPrivateConversation extends ConsumerWidget {
  const ChatSessionDetailsPrivateConversation(
      {super.key, required this.contact});

  final UserContact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = AppLocalizations.of(context);
    const divider = THorizontalDivider();
    final intro = contact.intro;
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SelectionArea(child: Text(contact.name)),
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
                softWrap: true,
                maxLines: 4,
                style: ThemeConfig.textStyleSecondary,
                overflow: TextOverflow.ellipsis,
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
        TTextButton(
          text: appLocalizations.leaveGroup,
        )
      ],
    );
  }
}
