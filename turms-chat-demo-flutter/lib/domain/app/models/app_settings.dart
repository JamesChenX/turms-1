import '../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../infra/sqlite/app_database.dart';
import 'app_setting.dart';

class AppSettings {
  AppSettings(this._idToSetting);

  factory AppSettings.fromTableData(List<AppSettingTableData> records) {
    final idToSetting = {
      for (final entry in records.map((r) => (AppSetting.fromId(r.id), r)))
        entry.$1: _parseValue(entry.$1, entry.$2.value.rawSqlValue)
    };
    return AppSettings(idToSetting);
  }

  final Map<AppSetting, Object> _idToSetting;

  static Object _parseValue(AppSetting setting, Object value) =>
      switch (setting) {
        AppSetting.rememberMe => (value as int).toBool(),
      };

  bool? getRememberMe() {
    final setting = _idToSetting[AppSetting.rememberMe];
    if (setting == null) {
      return null;
    }
    return setting as bool;
  }
}
