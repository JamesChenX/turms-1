import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../infra/io/global_keyboard_listener.dart';
import '../../l10n/app_localizations.dart';
import '../../themes/app_theme_extension.dart';
import '../../themes/theme_config.dart';
import 'app_controller.dart';
import 'home_page/home_page.dart';
import 'login_page/login_page.dart';

class AppView extends StatelessWidget {
  const AppView(this.appController, {super.key});

  final AppController appController;

  @override
  Widget build(BuildContext context) {
    final themeData = appController.themeData;
    final appThemeExtension = themeData.extension<AppThemeExtension>()!;
    final themeMode = appThemeExtension.themeMode;
    return MaterialApp(
        locale: appController.locale,
        debugShowCheckedModeBanner: false,
        navigatorKey: appController.navigatorKey,
        themeMode: themeMode,
        theme: themeMode == ThemeMode.light ? themeData : null,
        darkTheme: themeMode == ThemeMode.dark ? themeData : null,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        localeListResolutionCallback: appController.resolveLocale,
        home: Material(
          child: GlobalKeyboardListener(
            onKeyEvent: appController.onKeyEvent,
            child: appController.shouldDisplayLoginPage
                ? const ClipRRect(
                    borderRadius: ThemeConfig.borderRadius8,
                    child: LoginPage(),
                  )
                : ClipRRect(
                    borderRadius: appController.isWindowMaximized
                        ? ThemeConfig.borderRadius0
                        : ThemeConfig.borderRadius8,
                    child: const HomePage(),
                  ),
          ),
        ));
  }
}
