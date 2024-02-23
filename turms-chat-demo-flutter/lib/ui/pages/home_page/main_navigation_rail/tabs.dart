import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../../infra/keyboard/shortcut_extensions.dart';
import '../../../components/t_button/t_icon_button.dart';
import '../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../themes/theme_config.dart';
import '../about_page/about_page.dart';
import '../action_to_shortcut_view_model.dart';
import '../home_page_action.dart';
import '../home_page_tab.dart';
import '../settings_page/settings_page.dart';
import '../shared_view_models/home_page_tab_view_model.dart';

class Tabs extends ConsumerStatefulWidget {
  const Tabs({super.key});

  @override
  ConsumerState createState() => _TabsState();
}

class _TabsState extends ConsumerState<Tabs> {
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    final homePageTab = ref.watch(homePageTabViewModel);
    final isChatTab = homePageTab == HomePageTab.chat;
    final isContactsTab = homePageTab == HomePageTab.contacts;
    final isFilesTab = homePageTab == HomePageTab.files;
    // final isSettingsTab = homePageTab == HomePageTab.settings;
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    final actionToShortcut = ref.watch(actionToShortcutViewModel);

    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(children: [
        TIconButton(
            iconData: Symbols.chat,
            iconFill: isChatTab,
            iconSize: 26,
            iconWeight: isChatTab ? 400 : 300,
            tooltip:
                '${appLocalizations.chats} (${actionToShortcut[HomePageAction.showChatPage]!.description})',
            onTap: () => ref.read(homePageTabViewModel.notifier).state =
                HomePageTab.chat,
            iconColor: isChatTab ? ThemeConfig.primary : Colors.white54,
            iconHoverColor: isChatTab ? ThemeConfig.primary : Colors.white70),
        const SizedBox(height: 4),
        TIconButton(
            iconData: Symbols.person,
            iconFill: isContactsTab,
            iconSize: 26,
            iconWeight: isContactsTab ? 400 : 300,
            tooltip:
                '${appLocalizations.contacts} (${actionToShortcut[HomePageAction.showContactsPage]!.description})',
            onTap: () => ref.read(homePageTabViewModel.notifier).state =
                HomePageTab.contacts,
            iconColor: isContactsTab ? ThemeConfig.primary : Colors.white54,
            iconHoverColor:
                isContactsTab ? ThemeConfig.primary : Colors.white70),
        const SizedBox(height: 4),
        TIconButton(
            iconData: Symbols.description,
            iconFill: isFilesTab,
            iconSize: 26,
            iconWeight: isFilesTab ? 400 : 300,
            tooltip:
                '${appLocalizations.files} (${actionToShortcut[HomePageAction.showFilesPage]!.description})',
            onTap: () => ref.read(homePageTabViewModel.notifier).state =
                HomePageTab.files,
            iconColor: isFilesTab ? ThemeConfig.primary : Colors.white54,
            iconHoverColor: isFilesTab ? ThemeConfig.primary : Colors.white70),
      ]),
      MenuAnchor(
        controller: _menuController,
        consumeOutsideTap: true,
        alignmentOffset: const Offset(56, 0),
        menuChildren: <Widget>[
          MenuItemButton(
            child: Text(appLocalizations.settings),
            onPressed: () {
              showSettingsDialog(context);
            },
          ),
          MenuItemButton(
            child: Text(appLocalizations.about),
            onPressed: () {
              showAppAboutDialog(context);
            },
          ),
          MenuItemButton(
            child: Text(appLocalizations.logOut),
            onPressed: () {
              // TODO: Reset all states related to the logged-in user.
              ref.read(loggedInUserViewModel.notifier).state = null;
            },
          ),
        ],
        child: TIconButton(
            iconData: Symbols.menu_sharp,
            // iconData: Symbols.settings,
            // iconFill: isSettingsTab,
            iconSize: 26,
            iconWeight: 300,
            tooltip: appLocalizations.settings,
            onTapDown: (details) {
              _menuController.open();
            },
            iconColor: Colors.white54,
            iconHoverColor: Colors.white70),
      ),
    ]);
  }
}
