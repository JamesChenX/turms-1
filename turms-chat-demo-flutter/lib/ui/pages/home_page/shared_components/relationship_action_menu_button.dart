import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../components/t_button/t_icon_button.dart';
import '../../../l10n/view_models/app_localizations_view_model.dart';

class RelationshipActionMenuButton extends ConsumerWidget {
  RelationshipActionMenuButton({super.key});

  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    return MenuAnchor(
      controller: _menuController,
      consumeOutsideTap: true,
      alignmentOffset: const Offset(56, 0),
      menuChildren: <Widget>[
        // MenuItemButton(
        //   child: Text(appLocalizations.settings),
        //   onPressed: () {
        //     showSettingsDialog(context);
        //   },
        // ),
        // MenuItemButton(
        //   child: Text(appLocalizations.about),
        //   onPressed: () {
        //     showAppAboutDialog(context);
        //   },
        // ),
        // MenuItemButton(
        //   child: Text(appLocalizations.logOut),
        //   onPressed: () {
        //     // TODO: Reset all states related to the logged-in user.
        //     ref.read(loggedInUserInfoViewModel.notifier).state = null;
        //   },
        // ),
      ],
      child: TIconButton(
          iconData: Symbols.plus_one_rounded,
          iconSize: 26,
          iconWeight: 300,
          tooltip: appLocalizations.settings,
          onPanDown: (details) {
            _menuController.open();
          },
          iconColor: Colors.white54,
          iconColorHovered: Colors.white70),
    );
  }
}
