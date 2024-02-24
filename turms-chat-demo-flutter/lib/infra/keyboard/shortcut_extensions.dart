import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'shortcut_utils.dart';

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

  String toStoredString() => ShortcutUtils.toStoredString(this);

  String get description {
    if (triggers?.isNotEmpty == false) {
      return '';
    }
    final buffer = StringBuffer();
    // LogicalKeySet
    switch (this) {
      case LogicalKeySet():
        final keys = (this as LogicalKeySet).keys;
        for (final key in keys) {
          if (buffer.isNotEmpty) {
            buffer.write(' + ');
          }
          if (key == LogicalKeyboardKey.control) {
            buffer.write('Ctrl');
          } else {
            buffer.write(key.keyLabel);
          }
        }
        return buffer.toString();
      case SingleActivator():
        final activator = this as SingleActivator;
        if (activator.alt) {
          buffer.write('Alt');
        }
        if (activator.control) {
          if (buffer.isNotEmpty) {
            buffer.write(' + ');
          }
          buffer.write('Ctrl');
        }
        if (activator.meta) {
          if (buffer.isNotEmpty) {
            buffer.write(' + ');
          }
          buffer.write('Meta');
        }
        if (activator.shift) {
          if (buffer.isNotEmpty) {
            buffer.write(' + ');
          }
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
