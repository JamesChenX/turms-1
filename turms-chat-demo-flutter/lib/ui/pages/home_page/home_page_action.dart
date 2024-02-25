import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/user/models/index.dart';
import '../../../domain/user/models/user_setting_ids.dart';

enum HomePageAction {
  showChatPage(
      userSettingId: UserSettingId.shortcutShowChatPage,
      defaultShortcutActivator:
          SingleActivator(LogicalKeyboardKey.digit1, alt: true)),
  showContactsPage(
      userSettingId: UserSettingId.shortcutShowContactsPage,
      defaultShortcutActivator:
          SingleActivator(LogicalKeyboardKey.digit2, alt: true)),
  showFilesPage(
      userSettingId: UserSettingId.shortcutShowFilesPage,
      defaultShortcutActivator:
          SingleActivator(LogicalKeyboardKey.digit3, alt: true)),
  showSettingsDialog(
      userSettingId: UserSettingId.shortcutShowSettingsDialog,
      defaultShortcutActivator:
          SingleActivator(LogicalKeyboardKey.digit4, alt: true)),
  showAboutDialog(
      userSettingId: UserSettingId.shortcutShowAboutDialog,
      defaultShortcutActivator:
          SingleActivator(LogicalKeyboardKey.digit5, alt: true));

  const HomePageAction(
      {required this.userSettingId, required this.defaultShortcutActivator});

  final UserSettingId userSettingId;
  final ShortcutActivator defaultShortcutActivator;
}
