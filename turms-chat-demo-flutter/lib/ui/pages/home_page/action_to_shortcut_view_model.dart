import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/user/view_models/user_settings_view_model.dart';
import 'home_page_action.dart';

final actionToShortcutViewModel =
    StateProvider<Map<HomePageAction, ShortcutActivator>>((ref) {
  final map = {
    for (final type in HomePageAction.values)
      type: type.defaultShortcutActivator,
  };
  final userSettings = ref.watch(userSettingsViewModel);
  if (userSettings == null) {
    return map;
  }
  final shortcutShowChatPage = userSettings.shortcutShowChatPage;
  final shortcutShowContactsPage = userSettings.shortcutShowContactsPage;
  final shortcutShowFilesPage = userSettings.shortcutShowFilesPage;
  final shortcutShowSettingsDialog = userSettings.shortcutShowSettingsDialog;
  final shortcutShowAboutDialog = userSettings.shortcutShowAboutDialog;
  if (shortcutShowChatPage != null) {
    map[HomePageAction.showChatPage] = shortcutShowChatPage;
  }
  if (shortcutShowContactsPage != null) {
    map[HomePageAction.showContactsPage] = shortcutShowContactsPage;
  }
  if (shortcutShowFilesPage != null) {
    map[HomePageAction.showFilesPage] = shortcutShowFilesPage;
  }
  if (shortcutShowSettingsDialog != null) {
    map[HomePageAction.showSettingsDialog] = shortcutShowSettingsDialog;
  }
  if (shortcutShowAboutDialog != null) {
    map[HomePageAction.showAboutDialog] = shortcutShowAboutDialog;
  }
  return map;
});
