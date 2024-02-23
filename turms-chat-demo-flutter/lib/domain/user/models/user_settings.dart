import 'dart:ui';

import '../../../infra/sqlite/user_database.dart';
import 'user_setting_ids.dart';

class UserSettings {
  UserSettings(this._idToSetting);

  factory UserSettings.fromTableData(List<UserSettingTableData> records) {
    final idToSetting = <String, String?>{};
    for (final record in records) {
      idToSetting[record.id] = record.value;
    }
    return UserSettings(idToSetting);
  }

  final Map<String, String?> _idToSetting;

  Locale? get locale {
    final locale = _idToSetting[UserSettingIds.locale];
    if (locale == null) {
      return null;
    }
    return Locale(locale);
  }

  set locale(Locale? value) {
    _idToSetting[UserSettingIds.locale] = value?.languageCode;
  }

  String? get theme => _idToSetting[UserSettingIds.theme];

  set theme(String? value) {
    _idToSetting[UserSettingIds.theme] = value;
  }
}
