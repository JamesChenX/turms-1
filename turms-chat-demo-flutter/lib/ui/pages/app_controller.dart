import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../domain/user/view_models/user_settings_view_model.dart';
import '../../domain/window/view_models/window_maximized_view_model.dart';
import '../../infra/app/app_config.dart';
import '../../infra/window/window_utils.dart';
import '../components/t_dialog.dart';
import '../l10n/app_localizations.dart';
import '../l10n/view_models/app_localizations_view_model.dart';
import '../l10n/view_models/use_system_locale_view_model.dart';
import '../themes/app_theme.dart';
import '../themes/app_theme_view_model.dart';
import 'app.dart';
import 'app_view.dart';

class AppController extends ConsumerState<App> with WindowListener {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  late AppTheme appTheme;

  bool shouldDisplayLoginPage = true;
  bool isDisplayingLoginPage = true;
  late bool isWindowMaximized;
  bool isWindowSettingUp = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    WindowUtils.show();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayLoginPage = ref.watch(loggedInUserViewModel) == null;
    if (shouldDisplayLoginPage != displayLoginPage && !isWindowSettingUp) {
      _hideAndResize(displayLoginPage).then((value) {
        shouldDisplayLoginPage = displayLoginPage;
        setState(() {});
        SchedulerBinding.instance.addPostFrameCallback((_) {
          WindowUtils.show();
        });
      });
    }
    appTheme = ref.watch(appThemeViewModel);
    isWindowMaximized = ref.watch(isWindowMaximizedViewModel);
    return AppView(this);
  }

  @override
  void onWindowFocus() {
    setState(() {});
  }

  Future<void> _hideAndResize(bool resizeForLoginPage) async {
    isWindowSettingUp = true;
    // Hide first to resize and paint.
    await WindowUtils.hide();
    // When hide() returns, the window may be hided or hiding (animation),
    // so we wait for 300 millis to ensure the window is hided.
    await Future.delayed(const Duration(milliseconds: 300));
    if (resizeForLoginPage) {
      // Note that: We must set the min size first and then resize
      // because if setting the min size and resizing in one call,
      // the previous min size will restrict the current resize
      // on window_manager (0.3.7).
      await WindowUtils.setupWindow(
          minimumSize: AppConfig.defaultWindowSizeBeforeLogin);
      await WindowUtils.setupWindow(
          size: AppConfig.defaultWindowSizeBeforeLogin,
          backgroundColor: Colors.transparent);
    } else {
      await WindowUtils.setupWindow(
          minimumSize: AppConfig.minWindowSizeAfterLogin);
      await WindowUtils.setupWindow(
          size: AppConfig.defaultWindowSizeAfterLogin,
          resizable: true,
          backgroundColor: Colors.white);
    }
    isWindowSettingUp = false;
  }

  bool onKeyEvent(KeyEvent event) {
    var hasRouteRemoved = false;
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      final currentState = navigatorKey.currentState;
      if (currentState?.mounted ?? false) {
        currentState!.popUntil((route) {
          // Check "!hasRouteRemoved" to only remove the first TDialog route.
          if (!hasRouteRemoved && isTDialogRoute(route) && route.isActive) {
            hasRouteRemoved = true;
            return false;
          }
          return true;
        });
      }
    }
    return hasRouteRemoved;
  }

  Locale? resolveLocale(
      List<Locale>? locales, Iterable<Locale> supportedLocales) {
    final locale = ref.read(userSettingsViewModel)?.locale;
    if (locale != null) {
      return locale;
    }
    final useSystemLocale = ref.read(useSystemLocaleViewModel);
    if (useSystemLocale) {
      return WidgetsBinding.instance.platformDispatcher.locale;
    }
    final localeName = ref.read(appLocalizationsViewModel).localeName;
    return Locale(localeName);
  }
}
