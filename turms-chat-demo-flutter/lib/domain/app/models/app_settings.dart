import '../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../infra/sqlite/app_database.dart';
import 'app_setting_ids.dart';

class AppSettings {
  AppSettings(this._idToSetting);

  factory AppSettings.fromTableData(List<AppSettingTableData> records) {
    final idToSetting = <String, String?>{};
    for (final record in records) {
      idToSetting[record.id] = record.value;
    }
    return AppSettings(idToSetting);
  }

  final Map<String, String?> _idToSetting;

  bool? getRememberMe() {
    final setting = _idToSetting[AppSettingIds.rememberMe];
    if (setting == null) {
      return null;
    }
    return setting.toBool();
  }
}