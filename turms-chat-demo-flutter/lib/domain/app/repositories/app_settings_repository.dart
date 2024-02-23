import 'package:drift/drift.dart';

import '../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../infra/sqlite/app_database.dart';
import '../models/app_setting_ids.dart';

class AppSettingsRepository {
  Future<void> upsertRememberMe(bool rememberMe) async {
    final now = DateTime.now();
    final rememberMeStr = rememberMe.toIntString();
    await appDatabase.into(appDatabase.appSettingTable).insert(
        AppSettingTableCompanion.insert(
          id: AppSettingIds.rememberMe,
          value: Value(rememberMeStr),
          createdDate: now,
          lastModifiedDate: now,
        ),
        onConflict: DoUpdate((old) => AppSettingTableCompanion.custom(
            value: Constant(rememberMeStr), lastModifiedDate: Constant(now))));
  }

  Future<List<AppSettingTableData>> selectAll() =>
      appDatabase.select(appDatabase.appSettingTable).get();
}

final appSettingsRepository = AppSettingsRepository();
