import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../domain/user/models/contact.dart';
import '../../../../../components/t_button/t_text_button.dart';
import '../../../../../components/t_divider/t_horizontal_divider.dart';
import '../../../../../components/t_switch/t_switch.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../themes/theme_config.dart';

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
  bool muteNotifications = false;
  bool stickOnTop = false;

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
        divider,
        SizedBox(
          width: double.infinity,
          child: TTextButton(
            containerPadding: const EdgeInsets.symmetric(vertical: 16),
            // addContainer: false,
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