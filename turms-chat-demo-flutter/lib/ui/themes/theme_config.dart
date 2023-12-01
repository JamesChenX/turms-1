import 'package:flutter/material.dart';

class ThemeConfig {
  ThemeConfig._();

  static const Color gray5 = Color(0xFFD9D9D9);
  static const Color gray6 = Color(0xFFbfbfbf);
  static const Color gray7 = Color(0xFF8c8c8c);
  static const Color gray9 = Color(0xFF434343);

  //Colors for theme
  static const Color primary = Color(0xff1890ff);
  static const Color lightPrimary = Color(0xffffffff);
  static const Color darkPrimary = Color(0xff1f1f1f);
  static Color lightAccent = Colors.blue.shade700;
  static const Color darkAccent = Colors.lightBlue;
  static const Color lightBG = Color(0xfffFfFff);
  static const Color darkBG = Color(0xff121212);
  static Color error = Colors.red.shade200;
  static const Color focusedError = Colors.red;

  // static const Color badgeColor = Colors.red;
  static const Color separator = Color(0xffd9d9d9);

  static const Color borderDefaultColor = gray5;
  static const Color textColor = Color(0xE0000000);
  static const Color secondaryTextColor = Color(0xA6000000);
  static const Color checkboxColor = gray6;
  static const Color titleBarColor = gray9;

  static const Color conversationBackgroundColor =
      Color.fromARGB(255, 233, 233, 233);
  static const Color conversationHoverBackgroundColor =
      Color.fromARGB(255, 218, 218, 218);
  static const Color conversationFocusBackgroundColor =
      Color.fromARGB(255, 200, 200, 200);

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      // splashFactory: NoSplash.splashFactory,
      primaryColor: primary,
      unselectedWidgetColor: borderDefaultColor,
      // listTileTheme: const ListTileThemeData(
      //   horizontalTitleGap: 4,
      // ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: lightAccent,
        background: lightBG,
        brightness: Brightness.light,
      ),
      // textTheme: TextTheme(
      //   co
      //   // labelMedium: TextStyle(
      //   //   color:
      //   // )
      // ),
      fontFamily: 'Microsoft YaHei',
      fontFamilyFallback: [
        'PingFang SC',
        'Microsoft YaHei',
        'Source Han Sans SC',
        'Noto Sans CJK SC',
        'Segoe UI',
        'Noto Sans'
      ],
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.black),
      inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          border: InputBorder.none)
      // # TODO: text anti-aliasing:
      // https://github.com/flutter/flutter/issues/53308
      // https://github.com/flutter/flutter/issues/63043
      // https://github.com/flutter/flutter/issues/67034
      //
      // fontFamily: "Microsoft YaHei"
      // textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    // splashFactory: NoSplash.splashFactory,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBG,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: darkAccent,
      background: darkBG,
      brightness: Brightness.dark,
    ),
  );
}