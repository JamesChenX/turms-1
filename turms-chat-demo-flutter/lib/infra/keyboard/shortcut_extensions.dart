import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ShortcutActivatorExtensions on ShortcutActivator {
  List<LogicalKeyboardKey> get keys {
    switch (this) {
      case SingleActivator():
        final singleActivator = this as SingleActivator;
        if (singleActivator.control) {
          return [
            LogicalKeyboardKey.control,
            singleActivator.trigger,
          ];
        } else if (singleActivator.shift) {
          return [
            LogicalKeyboardKey.shift,
            singleActivator.trigger,
          ];
        } else if (singleActivator.alt) {
          return [
            LogicalKeyboardKey.alt,
            singleActivator.trigger,
          ];
        } else if (singleActivator.meta) {
          return [
            LogicalKeyboardKey.meta,
            singleActivator.trigger,
          ];
        } else {
          return [singleActivator.trigger];
        }
      case LogicalKeySet():
        return (this as LogicalKeySet).triggers.toList();
      default:
        return [];
    }
  }

  String get description {
    if (triggers?.isNotEmpty == false) {
      return '';
    }
    final buffer = StringBuffer();
    // LogicalKeySet
    switch (this) {
      case KeySet():
        final keys = (this as KeySet).keys;
        for (final key in keys) {
          if (buffer.isNotEmpty) {
            buffer.write(' + ');
          }
          final logicalKeyboardKey = key as LogicalKeyboardKey;
          if (logicalKeyboardKey == LogicalKeyboardKey.control) {
            buffer.write('Ctrl');
          } else {
            buffer.write(logicalKeyboardKey.keyLabel);
          }
        }
        return buffer.toString();
      case SingleActivator():
        final activator = this as SingleActivator;
        if (activator.alt) {
          buffer.write('Alt');
        } else if (activator.control) {
          buffer.write('Ctrl');
        } else if (activator.meta) {
          buffer.write('Meta');
        } else if (activator.shift) {
          buffer.write('Shift');
        }
        buffer.write(' + ');
        buffer.write(activator.trigger.keyLabel);
        return buffer.toString();
      default:
        return '';
    }
  }
}