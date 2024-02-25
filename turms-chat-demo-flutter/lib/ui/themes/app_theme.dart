import 'dart:io';

import 'package:pixel_snap/material.dart';

class AppTheme {
  const AppTheme({this.locale, required this.themeMode});

  /// if null, follow system settings.
  final Locale? locale;

  String? get fontFamily {
    if (!Platform.isWindows) {
      return null;
    }
    // Used to fix the text rendering problem
    // mentioned in https://github.com/flutter/flutter/issues/63043.
    // Reference: https://learn.microsoft.com/en-us/windows/apps/design/globalizing/loc-international-fonts.
    return switch (locale?.languageCode) {
      'ja' => 'Yu Gothic UI',
      'ko' => 'Malgun Gothic',
      'zh' || 'zh_CN' => 'Microsoft YaHei UI',
      'zh_HK' || 'zh_TW' => 'Microsoft JhengHei UI',
      _ => null
    };
  }

  final ThemeMode themeMode;
}
