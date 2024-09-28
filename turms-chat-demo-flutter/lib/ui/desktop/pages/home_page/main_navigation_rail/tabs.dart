import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../../../infra/keyboard/shortcut_extensions.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../themes/theme_config.dart';
import '../../../components/t_button/t_icon_button.dart';
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
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    final actionToShortcut = ref.watch(actionToShortcutViewModel);

    final shortcutShowChatPage =
        actionToShortcut[HomePageAction.showChatPage]?.shortcutActivator;
    final shortcutShowContactsPage =
        actionToShortcut[HomePageAction.showContactsPage]?.shortcutActivator;
    final shortcutShowFilesPage =
        actionToShortcut[HomePageAction.showFilesPage]?.shortcutActivator;
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(spacing: 4, children: [
        TIconButton(
            iconData: Symbols.chat_rounded,
            iconFill: isChatTab,
            iconSize: 26,
            iconWeight: isChatTab ? 400 : 300,
            tooltip: shortcutShowChatPage == null
                ? appLocalizations.chats
                : '${appLocalizations.chats} (${shortcutShowChatPage.description})',
            onTap: () => ref.read(homePageTabViewModel.notifier).state =
                HomePageTab.chat,
            iconColor: isChatTab ? ThemeConfig.primary : Colors.white54,
            iconColorHovered: isChatTab ? ThemeConfig.primary : Colors.white70),
        TIconButton(
            iconData: Symbols.person_rounded,
            iconFill: isContactsTab,
            iconSize: 26,
            iconWeight: isContactsTab ? 400 : 300,
            tooltip: shortcutShowContactsPage == null
                ? appLocalizations.contacts
                : '${appLocalizations.contacts} (${shortcutShowContactsPage.description})',
            onTap: () => ref.read(homePageTabViewModel.notifier).state =
                HomePageTab.contacts,
            iconColor: isContactsTab ? ThemeConfig.primary : Colors.white54,
            iconColorHovered:
                isContactsTab ? ThemeConfig.primary : Colors.white70),
        TIconButton(
            iconData: Symbols.description_rounded,
            iconFill: isFilesTab,
            iconSize: 26,
            iconWeight: isFilesTab ? 400 : 300,
            tooltip: shortcutShowFilesPage == null
                ? appLocalizations.files
                : '${appLocalizations.files} (${shortcutShowFilesPage.description})',
            onTap: () => ref.read(homePageTabViewModel.notifier).state =
                HomePageTab.files,
            iconColor: isFilesTab ? ThemeConfig.primary : Colors.white54,
            iconColorHovered:
                isFilesTab ? ThemeConfig.primary : Colors.white70),
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
            child: Text(
              appLocalizations.logOut,
              style: const TextStyle(color: Colors.red),
            ),
            onPressed: () {
              // TODO: Reset all states related to the logged-in user.
              ref.read(loggedInUserViewModel.notifier).state = null;
            },
          ),
        ],
        child: TIconButton(
            iconData: Symbols.menu_rounded,
            // iconData: Symbols.settings,
            // iconFill: isSettingsTab,
            iconSize: 26,
            iconWeight: 300,
            tooltip: appLocalizations.settings,
            onPanDown: (details) {
              _menuController.open();
            },
            iconColor: Colors.white54,
            iconColorHovered: Colors.white70),
      ),
    ]);
  }
}