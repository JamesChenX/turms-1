import 'package:drift/drift.dart';
import 'package:fixnum/fixnum.dart';

import '../../../infra/sqlite/user_database.dart';

class UserSettingsRepository {
  Int64? userId;
  String? userPassword;

  Future<void> upsert(
      Int64 userId, String settingId, String settingValue) async {
    final now = DateTime.now();
    final database = createUserDatabaseIfNotExists(userId);
    await database.into(database.userSettingTable).insert(
        UserSettingTableCompanion.insert(
          id: settingId,
          value: Value(settingValue),
          createdDate: now,
          lastModifiedDate: now,
        ),
        onConflict: DoUpdate((old) => UserSettingTableCompanion.custom(
            value: Constant(settingValue), lastModifiedDate: Constant(now))));
  }

  Future<int> delete(Int64 userId, String settingId) async {
    final database = createUserDatabaseIfNotExists(userId);
    final delete = database.delete(database.userSettingTable)
      ..where((t) => t.id.equals(settingId));
    return delete.go();
  }

  Future<List<UserSettingTableData>> selectAll(Int64 userId) {
    final database = createUserDatabaseIfNotExists(userId);
    return database.select(database.userSettingTable).get();
  }
}

final userSettingsRepository = UserSettingsRepository();