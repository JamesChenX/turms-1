import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';

import '../../domain/user/tables/user_setting_table.dart';
import '../env/env_vars.dart';
import 'core/database_utils.dart';

part 'user_database.g.dart';

@DriftDatabase(tables: [UserSettingTable])
class UserDatabase extends _$UserDatabase {
  UserDatabase(super.e);

  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration => MigrationStrategy(
      beforeOpen: (details) async {
        if (kDebugMode) {
          await validateDatabaseSchema();
        }
      }
  );
}

final _userIdToDatabase = <Int64, UserDatabase>{};

UserDatabase createUserDatabaseIfNotExists(Int64 userId) =>
    _userIdToDatabase.putIfAbsent(
        userId,
        () => UserDatabase(DatabaseUtils.createDatabase(
            dbName: 'user_${userId.toString()}',
            logStatements: EnvVars.databaseLogStatements)));