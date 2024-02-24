import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../infra/keyboard/shortcut_extensions.dart';
import '../../../infra/keyboard/shortcut_utils.dart';
import 'setting_action_on_close.dart';

enum UserSettingId {
  actionOnClose,
  checkForUpdatesAutomatically,
  launchOnStartup,
  locale,
  newMessageNotification,
  shortcutShowChatPage,
  shortcutShowContactsPage,
  shortcutShowFilesPage,
  shortcutShowSettingsDialog,
  shortcutShowAboutDialog,
  theme;

  String convertValueToString(Object value) => switch (this) {
        UserSettingId.actionOnClose => (value as SettingActionOnClose).name,
        UserSettingId.checkForUpdatesAutomatically =>
          (value as bool).toIntString(),
        UserSettingId.launchOnStartup =>
          throw UnsupportedError('Should not be called'),
        UserSettingId.locale => (value as Locale).languageCode,
        UserSettingId.newMessageNotification => (value as bool).toIntString(),
        UserSettingId.shortcutShowChatPage ||
        UserSettingId.shortcutShowContactsPage ||
        UserSettingId.shortcutShowFilesPage ||
        UserSettingId.shortcutShowSettingsDialog ||
        UserSettingId.shortcutShowAboutDialog =>
          (value as ShortcutActivator).toStoredString(),
        UserSettingId.theme => (value as ThemeMode).name,
      };

  T? convertStringToValue<T>(String value) => switch (this) {
        UserSettingId.actionOnClose =>
          SettingActionOnClose.values.firstOrNullByName(value),
        UserSettingId.checkForUpdatesAutomatically => value.toBool(),
        UserSettingId.launchOnStartup =>
          throw UnsupportedError('Should not be called'),
        UserSettingId.locale => Locale(value),
        UserSettingId.newMessageNotification => value.toBool(),
        UserSettingId.shortcutShowChatPage ||
        UserSettingId.shortcutShowContactsPage ||
        UserSettingId.shortcutShowFilesPage ||
        UserSettingId.shortcutShowSettingsDialog ||
        UserSettingId.shortcutShowAboutDialog =>
          ShortcutUtils.fromStoredString(value),
        UserSettingId.theme => ThemeMode.values.firstOrNullByName(value),
      } as T?;
}
