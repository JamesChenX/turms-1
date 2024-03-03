import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/user/view_models/user_settings_view_model.dart';
import 'home_page_action.dart';

final actionToShortcutViewModel =
    StateProvider<Map<HomePageAction, (ShortcutActivator?, bool)>>((ref) {
  // We allow the user unsetting shortcuts,
  // so don't assign default shortcut here.
  final map = <HomePageAction, (ShortcutActivator?, bool)>{};
  final userSettings = ref.watch(userSettingsViewModel);
  if (userSettings == null) {
    return map;
  }
  map[HomePageAction.showChatPage] = userSettings.shortcutShowChatPage;
  map[HomePageAction.showContactsPage] = userSettings.shortcutShowContactsPage;
  map[HomePageAction.showFilesPage] = userSettings.shortcutShowFilesPage;
  map[HomePageAction.showSettingsDialog] =
      userSettings.shortcutShowSettingsDialog;
  map[HomePageAction.showAboutDialog] = userSettings.shortcutShowAboutDialog;
  return map;
});
