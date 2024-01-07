import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme({this.locale, required this.themeMode});

  /// if null, follow system settings.
  final Locale? locale;

  final ThemeMode themeMode;
}