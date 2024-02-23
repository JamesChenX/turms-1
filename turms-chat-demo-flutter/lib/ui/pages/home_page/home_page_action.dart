import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum HomePageAction {
  showChatPage,
  showContactsPage,
  showFilesPage,
  showSettingsDialog,
  showAboutDialog
}

const _defaultShortcutShowChatPage =
    SingleActivator(LogicalKeyboardKey.digit1, alt: true);
const _defaultShortcutShowContactsPage =
    SingleActivator(LogicalKeyboardKey.digit2, alt: true);
const _defaultShortcutShowFilesPage =
    SingleActivator(LogicalKeyboardKey.digit3, alt: true);
const _defaultShortcutShowSettingsDialog =
    SingleActivator(LogicalKeyboardKey.digit4, alt: true);
const _defaultShortcutShowAboutDialog =
    SingleActivator(LogicalKeyboardKey.digit5, alt: true);

extension HomePageActionExtensions on HomePageAction {
  ShortcutActivator get defaultShortcutActivator {
    switch (this) {
      case HomePageAction.showChatPage:
        return _defaultShortcutShowChatPage;
      case HomePageAction.showContactsPage:
        return _defaultShortcutShowContactsPage;
      case HomePageAction.showFilesPage:
        return _defaultShortcutShowFilesPage;
      case HomePageAction.showSettingsDialog:
        return _defaultShortcutShowSettingsDialog;
      case HomePageAction.showAboutDialog:
        return _defaultShortcutShowAboutDialog;
    }
  }
}
