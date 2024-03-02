import 'dart:convert';
import 'dart:io';

import 'package:fixnum/fixnum.dart';

import '../sqlite/app_database.dart';
import '../sqlite/user_database.dart';
import 'log_appender.dart';
import 'log_entry.dart';

class LogAppenderDatabase extends LogAppender {
  LogAppenderDatabase({
    required this.userId,
  });

  final Int64 userId;

  @override
  void append(LogEntry entry) {}
}
