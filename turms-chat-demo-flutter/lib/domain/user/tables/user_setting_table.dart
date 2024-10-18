import 'package:drift/drift.dart';

class UserSettingTable extends Table {
  IntColumn get id => integer()();

  Column<DriftAny> get value => customType(DriftAnyType())();

  DateTimeColumn get createdDate => dateTime()();

  DateTimeColumn get lastModifiedDate => dateTime()();

  @override
  String get tableName => 'user_setting';

  @override
  bool get withoutRowId => true;

  @override
  Set<Column> get primaryKey => {id};
}

class DriftAnyType implements CustomSqlType<DriftAny> {
  @override
  String mapToSqlLiteral(DriftAny dartValue) =>
      dartValue.rawSqlValue.toString();

  @override
  Object mapToSqlParameter(DriftAny dartValue) => dartValue;

  @override
  DriftAny read(Object fromSql) => fromSql as DriftAny;

  @override
  String sqlTypeName(GenerationContext context) => 'ANY';
}
