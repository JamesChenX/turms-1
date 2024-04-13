import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/user/view_models/user_settings_view_model.dart';
import '../../../infra/app/app_config.dart';
import '../../../infra/env/env_vars.dart';
import '../../../infra/github/github_client.dart';
import '../../../infra/logging/logger.dart';
import '../../../infra/native/index.dart';
import '../../../infra/task/task_utils.dart';
import '../../../infra/units/file_size_extensions.dart';
import '../../components/index.dart';
import '../../components/t_alert/t_alert.dart';
import '../../components/t_lazy_indexed_stack/t_lazy_indexed_stack.dart';
import '../../components/t_title_bar/t_title_bar.dart';
import '../../l10n/view_models/app_localizations_view_model.dart';
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

const _taskIdCheckDiskSpace = 'checkDiskSpace';
const _taskIdCheckForUpdates = 'checkForUpdates';

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
                    child: TLazyIndexedStack(
                  index: switch (tab) {
                    HomePageTab.chat => 0,
                    HomePageTab.contacts => 1,
                    HomePageTab.files => 2,
                  },
                  children: [
                    const RepaintBoundary(child: ChatPage()),
                    const RepaintBoundary(child: ContactsPage()),
                    const RepaintBoundary(child: FilesPage()),
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

  @override
  void initState() {
    super.initState();
    TaskUtils.addPeriodicTask(
        id: _taskIdCheckForUpdates,
        duration: const Duration(hours: 1),
        callback: () async {
          final checkForUpdates =
              ref.read(userSettingsViewModel)?.checkForUpdatesAutomatically ??
                  false;
          if (!checkForUpdates) {
            return true;
          }
          try {
            final file = await GithubUtils.downloadLatestApp();
            // TODO: pop up a dialog to notify user.
          } catch (e, s) {
            logger.warn('Failed to download latest application', e, s);
          }
          return true;
        });
    TaskUtils.addPeriodicTask(
      id: _taskIdCheckDiskSpace,
      duration: const Duration(minutes: 3),
      callback: () async {
        final diskSpace = await appHostApi.getDiskSpace(AppConfig.appDir);
        if (diskSpace.usable < 100.MB) {
          final appLocalizations = ref.read(appLocalizationsViewModel);
          unawaited(showAlertDialog(
            context,
            title: appLocalizations.lowDiskSpace,
            content: appLocalizations.lowDiskSpacePrompt(100),
            onTapConfirm: () {
              Navigator.of(context).pop();
            },
          ));
        }
        return false;
      },
    );
  }

  @override
  void dispose() {
    TaskUtils.removeTask(_taskIdCheckForUpdates);
    TaskUtils.removeTask(_taskIdCheckDiskSpace);
    super.dispose();
  }
}
