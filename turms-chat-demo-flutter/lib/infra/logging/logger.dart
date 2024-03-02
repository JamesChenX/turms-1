import 'package:flutter/foundation.dart';

import 'log_appender.dart';
import 'log_appender_console.dart';
import 'log_appender_database.dart';
import 'log_entry.dart';
import 'log_level.dart';

class Logger {
  Logger({required this.level, required this.appenders});

  final LogLevel level;
  final List<LogAppender> appenders;

  void addAppender(LogAppender appender) {
    appenders.add(appender);
  }

  void removeAppender(LogAppender appender) {
    appenders.remove(appender);
  }

  void e(String message, [Object? error, StackTrace? stackTrace]) {
    log(LogEntry(LogLevel.error, message,
        error: error, stackTrace: stackTrace));
  }

  void w(String message) {
    log(LogEntry(LogLevel.warning, message));
  }

  void i(String message) {
    log(LogEntry(LogLevel.info, message));
  }

  void log(LogEntry entry) {
    if (level.value < entry.level.value) {
      return;
    }

    for (final appender in appenders) {
      appender.append(entry);
    }
  }
}

final logger = Logger(
  level: kDebugMode ? LogLevel.trace : LogLevel.info,
  appenders: kDebugMode ? [LogAppenderConsole()] : [],
);
