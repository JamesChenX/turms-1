import 'package:drift/drift.dart';

class UserSettingTable extends Table {
  TextColumn get id => text()();

  TextColumn get value => text().nullable()();

  DateTimeColumn get createdDate => dateTime()();

  DateTimeColumn get lastModifiedDate => dateTime()();

  @override
  String get tableName => 'user_setting';

  @override
  Set<Column> get primaryKey => {id};
}