import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseUtils {
  DatabaseUtils._();

  static QueryExecutor createDatabase({
    required String dbName,
    bool inMemory = false,
    required bool logStatements,
  }) {
    if (inMemory) {
      return NativeDatabase.memory(logStatements: logStatements);
    }
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(join(dir.path, 'database/$dbName.sqlite'));

      return NativeDatabase.createInBackground(file,
          logStatements: logStatements);
    });
  }
}
