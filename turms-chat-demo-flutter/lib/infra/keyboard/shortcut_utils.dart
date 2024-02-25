import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ShortcutUtils {
  ShortcutUtils._();

  static String toStoredString(ShortcutActivator activator) {
    final finalKeys = <int>[];
    switch (activator) {
      case LogicalKeySet():
        final keys = activator.keys;
        if (keys.isEmpty) {
          return '[]';
        }
        for (final key in keys) {
          finalKeys.add(key.keyId);
        }
        break;
      case SingleActivator():
        if (activator.alt) {
          finalKeys.add(LogicalKeyboardKey.alt.keyId);
        }
        if (activator.control) {
          finalKeys.add(LogicalKeyboardKey.control.keyId);
        }
        if (activator.meta) {
          finalKeys.add(LogicalKeyboardKey.meta.keyId);
        }
        if (activator.shift) {
          finalKeys.add(LogicalKeyboardKey.shift.keyId);
        }
        finalKeys.add(activator.trigger.keyId);
        break;
      default:
        throw UnsupportedError('Unsupported ShortcutActivator: $activator');
    }
    return jsonEncode(finalKeys);
  }

  static LogicalKeySet fromStoredString(String string) {
    final storedKeys = jsonDecode(string) as List;
    final keys = <LogicalKeyboardKey>{};
    for (final key in storedKeys) {
      keys.add(LogicalKeyboardKey(key as int));
    }
    return LogicalKeySet.fromSet(keys);
  }
}
