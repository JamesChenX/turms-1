import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../infra/ui/color_extensions.dart';
import '../../infra/ui/text_extensions.dart';

class ThemeConfig {
  ThemeConfig._();

  static final emojiFontFamily = switch (defaultTargetPlatform) {
    TargetPlatform.iOS || TargetPlatform.macOS => 'Apple Color Emoji',
    TargetPlatform.android ||
    TargetPlatform.fuchsia ||
    TargetPlatform.linux =>
      'Noto Color Emoji',
    TargetPlatform.windows => 'Segoe UI Emoji'
  };

  static const emojiFontFamilyFallback = [
    'Apple Color Emoji',
    'Segoe UI Emoji',
    'Segoe UI Symbol',
    'Noto Color Emoji',
    'Noto Color Emoji Compat',
    'Android Emoji',
    'EmojiSymbols'
  ];

  static const borderRadius0 = BorderRadius.zero;
  static const borderRadius4 = BorderRadius.all(Radius.circular(4));
  static const borderRadius8 = BorderRadius.all(Radius.circular(8));

  // base color palettes

  static const green6 = Color(0xFF52c41a);
  static const red5 = Color(0xFFFF4D4F);
  static const gold6 = Color(0xFFfaad14);

  static const blue5 = Color(0xFF4096FF);
  static const blue6 = Color(0xFF1677FF);

  static const gray5 = Color(0xFFD9D9D9);
  static const gray6 = Color(0xFFbfbfbf);
  static const gray7 = Color(0xFF8c8c8c);
  static const gray9 = Color(0xFF434343);

  // functional color palettes

  static const success = green6;
  static const warning = gold6;
  static const error = red5;
  static const info = blue6;

  static const linkColor = blue5;
  static const linkHoveredColor = blue6;

  //Colors for theme
  static const primary = Color(0xff1890ff);
  static final primaryDisabled = primary.lighten(0.5);

  static const lightPrimary = Color(0xffffffff);
  static const darkPrimary = Color(0xff1f1f1f);
  static final lightAccent = Colors.blue.shade700;
  static const darkAccent = Colors.lightBlue;
  static const lightBG = Color(0xfffFfFff);
  static const darkBG = Color(0xff121212);
  static const colorDisabled = Colors.black38;

  // static Color error = Colors.red.shade200;
  static const focusedError = Colors.red;

  // static const Color badgeColor = Colors.red;
  static const separator = Color(0xffd9d9d9);
  static const dividerColor = Colors.black12;

  static const dialogWidthMedium = 550.0;
  static const dialogHeightMedium = 470.0;

  static const borderDefaultColor = gray5;
  static const textColorPrimary = Color(0xE0000000);
  static const textColorSecondary = Color(0xA6000000);
  static const textColorDisabled = Colors.black26;
  static const checkboxColor = gray6;
  static const titleBarColor = gray9;

  static const paddingV4H8 = EdgeInsets.symmetric(vertical: 4, horizontal: 8);
  static const paddingV8H16 = EdgeInsets.symmetric(vertical: 8, horizontal: 16);
  static const paddingV16H8 = EdgeInsets.symmetric(vertical: 16, horizontal: 8);
  static const paddingH8 = EdgeInsets.symmetric(horizontal: 8);

  static const colorChatSessionPaneSeparator =
      Color.fromARGB(255, 231, 231, 231);

  // static const unit = 2.0;
  static const textStyleSecondary = TextStyle(color: textColorSecondary);
  static const textStyleHighlight = TextStyle(color: Colors.red);

  static const titleBarSize = Size(36, 28);

  static const homePageHeaderHeight = 60.0;
  static const homePageBackgroundColor = Color.fromARGB(255, 245, 245, 245);

  static const conversationBackgroundColor = Color.fromARGB(255, 233, 233, 233);
  static const conversationHoveredBackgroundColor =
      Color.fromARGB(255, 218, 218, 218);
  static const conversationFocusedBackgroundColor =
      Color.fromARGB(255, 200, 200, 200);
  static const boxShadow = [
    BoxShadow(
      // Colors.black.withOpacity(0.2),
      color: Color(0x33000000),
      offset: Offset(1, 1),
      blurRadius: 6,
    ),
  ];

  static ThemeData getLightTheme({String? fontFamily}) => ThemeData(
      useMaterial3: true,
      // splashFactory: NoSplash.splashFactory,
      primaryColor: primary,
      unselectedWidgetColor: borderDefaultColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: lightAccent,
        background: lightBG,
        brightness: Brightness.light,
      ),
      fontFamily: fontFamily,
      fontFamilyFallback: emojiFontFamilyFallback,
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.black),
      inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          border: InputBorder.none));

  // todo
  static ThemeData getDarkTheme({String? fontFamily}) => ThemeData(
      useMaterial3: true,
      // splashFactory: NoSplash.splashFactory,
      primaryColor: primary,
      unselectedWidgetColor: borderDefaultColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: lightAccent,
        background: lightBG,
        brightness: Brightness.light,
      ),
      fontFamily: fontFamily,
      fontFamilyFallback: emojiFontFamilyFallback,
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.black),
      inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          border: InputBorder.none));
}