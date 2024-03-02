import 'package:drift/drift.dart';
import 'package:logger/logger.dart';

class LogEntryTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get level => intEnum<Level>()();

  DateTimeColumn get timestamp => dateTime()();

  TextColumn get message => text()();

  @override
  String get tableName => 'log_entry';
}
