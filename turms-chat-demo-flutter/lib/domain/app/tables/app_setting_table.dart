import 'package:drift/drift.dart';

import '../../user/tables/user_setting_table.dart';

class AppSettingTable extends Table {
  IntColumn get id => integer()();

  Column<DriftAny> get value => customType(DriftAnyType())();

  DateTimeColumn get createdDate => dateTime()();

  DateTimeColumn get lastModifiedDate => dateTime()();

  @override
  String get tableName => 'app_setting';

  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => {id};
}
