import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  level: kReleaseMode ? Level.error : Level.all,
  printer: PrettyPrinter(methodCount: 0, printTime: true),
);