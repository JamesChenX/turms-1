import 'package:flutter/material.dart';

import '../../../infra/sqlite/user_database.dart';
import 'setting_action_on_close.dart';
import 'user_setting_ids.dart';

class UserSettings {
  UserSettings(this._idToSetting);

  factory UserSettings.fromTableData(List<UserSettingTableData> records) {
    final nameToSettingId = UserSettingId.values.asNameMap();
    final settings = UserSettings({});
    for (final record in records) {
      final settingId = nameToSettingId[record.id];
      final recordValue = record.value;
      if (settingId == null || recordValue == null) {
        continue;
      }
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
        case UserSettingId.theme:
          settings.theme = settingId.convertStringToValue(recordValue);
      }
    }
    return settings;
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

  ThemeMode? get theme => _idToSetting[UserSettingId.theme] as ThemeMode?;

  set theme(ThemeMode? value) => _idToSetting[UserSettingId.theme] = value;
}
