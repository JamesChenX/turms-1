import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  level: kDebugMode ? Level.all : Level.error,
  printer: PrettyPrinter(methodCount: 0, printTime: true),
);
