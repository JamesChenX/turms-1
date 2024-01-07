import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/user/view_models/user_settings_view_model.dart';
import 'app_theme.dart';

final appThemeViewModel = StateProvider<AppTheme>((ref) {
  final userSettings = ref.watch(userSettingsViewModel);
  if (userSettings == null) {
    return const AppTheme(themeMode: ThemeMode.system);
  }
  final themeMode = switch (userSettings.theme) {
    null => ThemeMode.system,
    'dark' => ThemeMode.dark,
    'light' => ThemeMode.light,
    _ => ThemeMode.system,
  };
  return AppTheme(locale: userSettings.locale, themeMode: themeMode);
});