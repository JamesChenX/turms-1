import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../../domain/user/models/contact.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../themes/index.dart';

import '../../../../../components/t_button/t_text_button.dart';
import '../../../../../components/t_divider/t_horizontal_divider.dart';
import '../../../../../components/t_switch/t_switch.dart';

class ChatSessionDetailsPrivateConversation extends ConsumerStatefulWidget {
  const ChatSessionDetailsPrivateConversation(
      {super.key, required this.contact});

  final UserContact contact;

  @override
  ConsumerState<ChatSessionDetailsPrivateConversation> createState() =>
      _ChatSessionDetailsPrivateConversationState();
}

class _ChatSessionDetailsPrivateConversationState
    extends ConsumerState<ChatSessionDetailsPrivateConversation> {
  // TODO: load from server + save to server
  bool _muteNotifications = false;
  bool _stickOnTop = false;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    const divider = THorizontalDivider();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(appLocalizations.muteNotifications),
            TSwitch(
              value: _muteNotifications,
              onChanged: (value) {
                _muteNotifications = value;
                setState(() {});
              },
            ),
          ],
        ),
        Sizes.sizedBoxH4,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(appLocalizations.stickOnTop),
            TSwitch(
              value: _stickOnTop,
              onChanged: (value) {
                _stickOnTop = value;
                setState(() {});
              },
            ),
          ],
        ),
        Sizes.sizedBoxH4,
        divider,
        Sizes.sizedBoxH8,
        TTextButton.outlined(
          theme: context.theme,
          containerPadding: Sizes.paddingV4H8,
          text: appLocalizations.addNewMember,
          prefix: const Icon(
            Symbols.person_add_rounded,
            size: 20,
          ),
        ),
        Sizes.sizedBoxH8,
        const Spacer(),
        divider,
        SizedBox(
          width: double.infinity,
          child: TTextButton(
            containerPadding: Sizes.paddingV8,
            containerColor: Colors.transparent,
            containerColorHovered: Colors.transparent,
            text: appLocalizations.clearChatHistory,
            textStyle: context.appThemeExtension.dangerTextStyle,
          ),
        )
      ],
    );
  }
}
