import 'package:drift/drift.dart';

import 'log_level_converter.dart';

class LogEntryTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get level => integer().map(LogLevelConverter())();

  DateTimeColumn get timestamp => dateTime()();

  TextColumn get message => text()();

  @override
  String get tableName => 'log_entry';
}
