import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../../domain/user/models/index.dart';
import '../../../../domain/user/models/user_setting.dart';

enum HomePageAction {
  showChatPage(
      userSetting: UserSetting.shortcutShowChatPage,
      defaultShortcutActivator:
          SingleActivator(LogicalKeyboardKey.digit1, alt: true)),
  showContactsPage(
      userSetting: UserSetting.shortcutShowContactsPage,
      defaultShortcutActivator:
          SingleActivator(LogicalKeyboardKey.digit2, alt: true)),
  showFilesPage(
      userSetting: UserSetting.shortcutShowFilesPage,
      defaultShortcutActivator:
          SingleActivator(LogicalKeyboardKey.digit3, alt: true)),
  showSettingsDialog(
      userSetting: UserSetting.shortcutShowSettingsDialog,
      defaultShortcutActivator:
          SingleActivator(LogicalKeyboardKey.digit4, alt: true)),
  showAboutDialog(
      userSetting: UserSetting.shortcutShowAboutDialog,
      defaultShortcutActivator:
          SingleActivator(LogicalKeyboardKey.digit5, alt: true));

  const HomePageAction(
      {required this.userSetting, required this.defaultShortcutActivator});

  final UserSetting<ShortcutActivator, Uint8List> userSetting;
  final ShortcutActivator defaultShortcutActivator;
}
