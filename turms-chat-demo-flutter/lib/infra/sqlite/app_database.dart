import 'package:drift/drift.dart';

import '../../domain/app/tables/app_setting_table.dart';
import '../../domain/user/tables/user_login_info_table.dart';
import '../env/env_vars.dart';
import 'core/database_utils.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [AppSettingTable, UserLoginInfoTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}

final appDatabase = AppDatabase(DatabaseUtils.createDatabase(
    dbName: 'app', logStatements: EnvVars.databaseLogStatements));