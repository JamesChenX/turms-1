import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infra/env/env_vars.dart';
import '../../components/t_focus_tracker.dart';
import '../../components/t_title_bar.dart';
import '../../themes/theme_config.dart';
import 'about_page/about_page.dart';
import 'action_to_shortcut_view_model.dart';
import 'chat_page/chat_page.dart';
import 'contacts_page/contacts_page.dart';
import 'files_page/files_page.dart';
import 'home_page_action.dart';
import 'home_page_tab.dart';
import 'main_navigation_rail/main_navigation_rail.dart';
import 'settings_page/settings_page.dart';
import 'shared_view_models/home_page_tab_view_model.dart';

class HomePageLandscape extends ConsumerStatefulWidget {
  const HomePageLandscape({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePageLandscape> createState() => _HomePageLandscapeState();
}

class _HomePageLandscapeState extends ConsumerState<HomePageLandscape> {
  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(homePageTabViewModel);
    final actionToShortcut = ref.watch(actionToShortcutViewModel);
    final bindings = <ShortcutActivator, VoidCallback>{};
    final shortcutShowChatPage =
        actionToShortcut[HomePageAction.showChatPage]!.$1;
    final shortcutShowContactsPage =
        actionToShortcut[HomePageAction.showContactsPage]!.$1;
    final shortcutShowFilesPage =
        actionToShortcut[HomePageAction.showFilesPage]!.$1;
    final shortcutShowSettingsDialog =
        actionToShortcut[HomePageAction.showSettingsDialog]!.$1;
    final shortcutShowAboutDialog =
        actionToShortcut[HomePageAction.showAboutDialog]!.$1;
    if (shortcutShowChatPage != null) {
      bindings[shortcutShowChatPage] = () =>
          ref.read(homePageTabViewModel.notifier).state = HomePageTab.chat;
    }
    if (shortcutShowContactsPage != null) {
      bindings[shortcutShowContactsPage] = () =>
          ref.read(homePageTabViewModel.notifier).state = HomePageTab.contacts;
    }
    if (shortcutShowFilesPage != null) {
      bindings[shortcutShowFilesPage] = () =>
          ref.read(homePageTabViewModel.notifier).state = HomePageTab.files;
    }
    if (shortcutShowSettingsDialog != null) {
      bindings[shortcutShowSettingsDialog] = () => showSettingsDialog(context);
    }
    if (shortcutShowAboutDialog != null) {
      bindings[shortcutShowAboutDialog] = () => showAppAboutDialog(context);
    }
    final child = CallbackShortcuts(
      bindings: bindings,
      child: FocusScope(
        debugLabel: 'HomePageLandscape',
        autofocus: true,
        child: Stack(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 56,
                  child: MainNavigationRail(),
                ),
                Expanded(
                    // child: IndexedStack(
                    child: IndexedStack(
                  index: switch (tab) {
                    HomePageTab.chat => 0,
                    HomePageTab.contacts => 1,
                    HomePageTab.files => 2,
                  },
                  children: [
                    const ChatPage(),
                    const ContactsPage(),
                    const FilesPage(),
                  ],
                ))
              ],
            ),
            const TTitleBar(
                backgroundColor: ThemeConfig.homePageBackgroundColor),
          ],
        ),
      ),
    );
    if (EnvVars.showFocusTracker) {
      // TODO
      // return TFocusTracker(
      //   child: child,
      // );
    }
    return child;
  }
}
