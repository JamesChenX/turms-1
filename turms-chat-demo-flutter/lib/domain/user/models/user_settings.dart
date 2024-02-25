import 'package:pixel_snap/material.dart';

import '../../../infra/exception/stackful_exception.dart';
import '../../../infra/sqlite/user_database.dart';
import 'setting_action_on_close.dart';
import 'user_setting_ids.dart';

class UserSettings {
  UserSettings(this._idToSetting);

  static (UserSettings, StackfulException?) fromTableData(
      List<UserSettingTableData> records) {
    final nameToSettingId = UserSettingId.values.asNameMap();
    final settings = UserSettings({});
    StackfulException? exception;
    for (final record in records) {
      final settingId = nameToSettingId[record.id];
      final recordValue = record.value;
      if (settingId == null || recordValue == null) {
        continue;
      }
      try {
        _setSetting(settings, settingId, recordValue);
      } on Exception catch (e, s) {
        exception ??= StackfulException(
            cause: Exception('Failed to set the user settings'),
            stackTrace: s,
            suppressed: []);
        exception.addSuppressed(StackfulException(
            cause: Exception(
                'Failed to set the user setting "$settingId" with the value "$recordValue"'),
            stackTrace: s,
            suppressed: [e]));
      }
    }
    return (settings, exception);
  }

  static void _setSetting(
      UserSettings settings, UserSettingId settingId, String recordValue) {
    switch (settingId) {
      case UserSettingId.actionOnClose:
        settings.actionOnClose = settingId.convertStringToValue(recordValue);
        break;
      case UserSettingId.checkForUpdatesAutomatically:
        settings.checkForUpdatesAutomatically =
            settingId.convertStringToValue(recordValue);
        break;
      case UserSettingId.launchOnStartup:
        // do nothing.
        // The setting should be detected according to whether autostart is enabled in system settings,
        // so it should not follow the stored setting.
        break;
      case UserSettingId.locale:
        settings.locale = settingId.convertStringToValue(recordValue);
        break;
      case UserSettingId.newMessageNotification:
        settings.newMessageNotification =
            settingId.convertStringToValue(recordValue);
        break;
      case UserSettingId.shortcutShowChatPage:
        settings.shortcutShowChatPage =
            settingId.convertStringToValue(recordValue);
        break;
      case UserSettingId.shortcutShowContactsPage:
        settings.shortcutShowContactsPage =
            settingId.convertStringToValue(recordValue);
        break;
      case UserSettingId.shortcutShowFilesPage:
        settings.shortcutShowFilesPage =
            settingId.convertStringToValue(recordValue);
        break;
      case UserSettingId.shortcutShowSettingsDialog:
        settings.shortcutShowSettingsDialog =
            settingId.convertStringToValue(recordValue);
        break;
      case UserSettingId.shortcutShowAboutDialog:
        settings.shortcutShowAboutDialog =
            settingId.convertStringToValue(recordValue);
        break;
      case UserSettingId.theme:
        settings.theme = settingId.convertStringToValue(recordValue);
    }
  }

  final Map<UserSettingId, Object?> _idToSetting;

  SettingActionOnClose? get actionOnClose =>
      _idToSetting[UserSettingId.actionOnClose] as SettingActionOnClose?;

  set actionOnClose(SettingActionOnClose? value) {
    _idToSetting[UserSettingId.actionOnClose] = value;
  }

  bool? get checkForUpdatesAutomatically =>
      _idToSetting[UserSettingId.checkForUpdatesAutomatically] as bool?;

  set checkForUpdatesAutomatically(bool? value) {
    _idToSetting[UserSettingId.checkForUpdatesAutomatically] = value;
  }

  bool? get launchOnStartup =>
      _idToSetting[UserSettingId.launchOnStartup] as bool?;

  set launchOnStartup(bool? value) {
    _idToSetting[UserSettingId.launchOnStartup] = value;
  }

  Locale? get locale => _idToSetting[UserSettingId.locale] as Locale?;

  set locale(Locale? value) => _idToSetting[UserSettingId.locale] = value;

  bool? get newMessageNotification =>
      _idToSetting[UserSettingId.newMessageNotification] as bool?;

  set newMessageNotification(bool? value) =>
      _idToSetting[UserSettingId.newMessageNotification] = value;

  ShortcutActivator? get shortcutShowChatPage =>
      _idToSetting[UserSettingId.shortcutShowChatPage] as ShortcutActivator?;

  set shortcutShowChatPage(ShortcutActivator? value) =>
      _idToSetting[UserSettingId.shortcutShowChatPage] = value;

  ShortcutActivator? get shortcutShowContactsPage =>
      _idToSetting[UserSettingId.shortcutShowContactsPage]
          as ShortcutActivator?;

  set shortcutShowContactsPage(ShortcutActivator? value) =>
      _idToSetting[UserSettingId.shortcutShowContactsPage] = value;

  ShortcutActivator? get shortcutShowFilesPage =>
      _idToSetting[UserSettingId.shortcutShowFilesPage] as ShortcutActivator?;

  set shortcutShowFilesPage(ShortcutActivator? value) =>
      _idToSetting[UserSettingId.shortcutShowFilesPage] = value;

  ShortcutActivator? get shortcutShowSettingsDialog =>
      _idToSetting[UserSettingId.shortcutShowSettingsDialog]
          as ShortcutActivator?;

  set shortcutShowSettingsDialog(ShortcutActivator? value) =>
      _idToSetting[UserSettingId.shortcutShowSettingsDialog] = value;

  ShortcutActivator? get shortcutShowAboutDialog =>
      _idToSetting[UserSettingId.shortcutShowAboutDialog] as ShortcutActivator?;

  set shortcutShowAboutDialog(ShortcutActivator? value) =>
      _idToSetting[UserSettingId.shortcutShowAboutDialog] = value;

  ThemeMode? get theme => _idToSetting[UserSettingId.theme] as ThemeMode?;

  set theme(ThemeMode? value) => _idToSetting[UserSettingId.theme] = value;
}
