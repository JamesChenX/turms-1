import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../components/t_responsive_layout.dart';
import '../l10n/app_localizations.dart';
import '../themes/theme_config.dart';
import 'app_controller.dart';
import 'home_page/home_page_landscape.dart';
import 'home_page/home_page_portrait.dart';
import 'login_page/login_page.dart';

class AppView extends StatelessWidget {
  const AppView(this.appController, {super.key});

  final AppController appController;

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeConfig.lightTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: appController.isWindowMaximized
            ? _buildPage()
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildPage(),
              ),
      );

  Widget _buildPage() {
    if (appController.shouldDisplayLoginPage) {
      return const LoginPage();
    } else {
      return _buildHomePage();
    }
  }

  Material _buildHomePage() => Material(
      key: appController.homePageKey,
      child: const TResponsiveLayout(
        portraitLayoutContent: HomePagePortrait(),
        landscapeLayoutContent: HomePageLandscape(),
      ));
}