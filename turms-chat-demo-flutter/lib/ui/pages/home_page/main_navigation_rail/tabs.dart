import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../components/components.dart';
import '../../../l10n/app_localizations.dart';
import '../../../themes/theme_config.dart';
import '../home_page_tab.dart';
import '../settings_page/settings_page.dart';
import '../shared_states/shared_states.dart';

class Tabs extends ConsumerStatefulWidget {
  const Tabs({super.key});

  @override
  ConsumerState createState() => _TabsState();
}

class _TabsState extends ConsumerState<Tabs> {
  @override
  Widget build(BuildContext context) {
    final homePageTab = ref.watch(homePageTabProvider);
    final isChatTab = homePageTab == HomePageTab.chat;
    final isContactsTab = homePageTab == HomePageTab.contacts;
    final isFilesTab = homePageTab == HomePageTab.files;
    // final isSettingsTab = homePageTab == HomePageTab.settings;
    final localizations = AppLocalizations.of(context);

    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(children: [
        TIconButton(
            iconData: Symbols.chat,
            iconFill: isChatTab,
            iconSize: 26,
            iconWeight: isChatTab ? 400 : 300,
            tooltip: localizations.chats,
            onPressed: () =>
                ref.read(homePageTabProvider.notifier).state = HomePageTab.chat,
            iconColor: isChatTab ? ThemeConfig.primary : Colors.white54,
            iconHoverColor: isChatTab ? ThemeConfig.primary : Colors.white70),
        const SizedBox(height: 4),
        TIconButton(
            iconData: Symbols.person,
            iconFill: isContactsTab,
            iconSize: 26,
            iconWeight: isContactsTab ? 400 : 300,
            tooltip: localizations.contacts,
            onPressed: () => ref.read(homePageTabProvider.notifier).state =
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
            tooltip: localizations.files,
            onPressed: () => ref.read(homePageTabProvider.notifier).state =
                HomePageTab.files,
            iconColor: isFilesTab ? ThemeConfig.primary : Colors.white54,
            iconHoverColor: isFilesTab ? ThemeConfig.primary : Colors.white70),
      ]),
      TIconButton(
          iconData: Symbols.settings,
          // iconFill: isSettingsTab,
          iconSize: 26,
          iconWeight: 300,
          tooltip: localizations.settings,
          onPressed: () {
            showSettingsDialog(context);
          },
          iconColor: Colors.white54,
          iconHoverColor: Colors.white70),
    ]);
  }
}