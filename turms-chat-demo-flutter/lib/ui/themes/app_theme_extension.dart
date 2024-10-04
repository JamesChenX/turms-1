import 'package:flutter/material.dart';

sealed class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({required this.themeMode});

  final ThemeMode themeMode;

  @override
  ThemeExtension<AppThemeExtension> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
      covariant ThemeExtension<AppThemeExtension>? other, double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }
}

class AppThemeExtensionLight extends AppThemeExtension {
  const AppThemeExtensionLight() : super(themeMode: ThemeMode.light);
}

class AppThemeExtensionDark extends AppThemeExtension {
  const AppThemeExtensionDark() : super(themeMode: ThemeMode.dark);
}
