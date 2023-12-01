import 'package:drift/drift.dart';

class UserLoginInfoTable extends Table {
  Int64Column get userId => int64()();

  TextColumn get password => text()();

  DateTimeColumn get createdDate => dateTime()();

  DateTimeColumn get lastModifiedDate => dateTime()();

  @override
  String get tableName => 'user_login_info';

  @override
  Set<Column> get primaryKey => {userId};
}