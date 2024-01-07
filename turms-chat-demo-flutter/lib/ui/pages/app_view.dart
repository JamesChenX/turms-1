import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../infra/io/global_keyboard_listener.dart';
import '../l10n/app_localizations.dart';
import '../themes/theme_config.dart';
import 'app_controller.dart';
import 'home_page/home_page.dart';
import 'login_page/login_page.dart';

class AppView extends StatelessWidget {
  const AppView(this.appController, {super.key});

  final AppController appController;

  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: appController.appTheme.locale,
      debugShowCheckedModeBanner: false,
      navigatorKey: appController.navigatorKey,
      themeMode: appController.appTheme.themeMode,
      theme: ThemeConfig.lightTheme,
      // darkTheme: ThemeConfig.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: GlobalKeyboardListener(
        onKeyEvent: appController.onKeyEvent,
        child: appController.isWindowMaximized
            ? _buildPage()
            : ClipRRect(
                borderRadius: ThemeConfig.borderRadius8,
                child: _buildPage(),
              ),
      ));

  Widget _buildPage() {
    if (appController.shouldDisplayLoginPage) {
      return const LoginPage();
    } else {
      return _buildHomePage();
    }
  }

  Material _buildHomePage() =>
      Material(key: appController.homePageKey, child: const HomePage());
}