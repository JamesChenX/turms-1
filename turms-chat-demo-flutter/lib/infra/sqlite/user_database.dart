import 'package:drift/drift.dart';

import '../../domain/user/tables/user_setting_table.dart';

part 'user_database.g.dart';

@DriftDatabase(tables: [UserSettingTable])
class UserDatabase extends _$UserDatabase {
  UserDatabase(super.e);

  @override
  int get schemaVersion => 1;
}