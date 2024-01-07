import 'package:flutter/services.dart';

extension LogicalKeyboardKeyExtensions on LogicalKeyboardKey {
  bool get isModifier =>
      this == LogicalKeyboardKey.control ||
      this == LogicalKeyboardKey.shift ||
      this == LogicalKeyboardKey.alt ||
      this == LogicalKeyboardKey.meta;

  LogicalKeyboardKey get normalizedKey => synonyms.firstOrNull ?? this;
}