import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../domain/window/view_models/window_maximized_view_model.dart';
import '../../../infra/app/app_config.dart';
import '../../../infra/window/window_utils.dart';
import '../../l10n/view_models/system_locale_info_view_model.dart';
import '../../themes/app_theme_view_model.dart';
import '../components/t_dialog/t_dialog.dart';
import 'app.dart';
import 'app_view.dart';

class AppController extends ConsumerState<App> with WindowListener {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  late Locale locale;
  late ThemeData themeData;

  bool shouldDisplayLoginPage = true;
  bool isDisplayingLoginPage = true;
  late bool isWindowMaximized;
  bool isWindowSettingUp = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    // show windows in the next frame to ensure the UI is ready.
    // Otherwise the UI will jitter because it is painting.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      WindowUtils.show();
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    locale = ref.watch(localeInfoViewModel).locale;
    themeData = ref.watch(themeViewModel);
    isWindowMaximized = ref.watch(isWindowMaximizedViewModel);

    ref.listen(loggedInUserViewModel,
        (previousLoggedInUser, currentLoggedInUser) {
      final displayLoginPage = currentLoggedInUser == null;
      if (shouldDisplayLoginPage != displayLoginPage && !isWindowSettingUp) {
        _hideAndResize(displayLoginPage).then((value) {
          shouldDisplayLoginPage = displayLoginPage;
          setState(() {});
          SchedulerBinding.instance.addPostFrameCallback((_) {
            WindowUtils.show();
          });
        });
      }
    });
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
    // so we wait to ensure the window is hided.
    await WindowUtils.waitUntilInvisible();
    if (resizeForLoginPage) {
      // Note that: We must set the min size first and then resize
      // because if setting the min size and resizing in one call,
      // the previous min size will restrict the current resize
      // on window_manager (0.3.7).
      await WindowUtils.setupWindow(
          minimumSize: AppConfig.defaultWindowSizeForLoginScreen);
      await WindowUtils.setupWindow(
          size: AppConfig.defaultWindowSizeForLoginScreen,
          backgroundColor: Colors.transparent);
    } else {
      await WindowUtils.setupWindow(
          minimumSize: AppConfig.minWindowSizeForHomeScreen);
      await WindowUtils.setupWindow(
          size: AppConfig.defaultWindowSizeForHomeScreen,
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
      if (currentState != null && currentState.mounted) {
        currentState.popUntil((route) {
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
          List<Locale>? locales, Iterable<Locale> supportedLocales) =>
      ref.read(localeInfoViewModel).locale;

  static void popTopIfNameMatched(String name) {
    final currentState = navigatorKey.currentState;
    if (currentState == null || !currentState.mounted) {
      return;
    }
    String? currentPath;
    currentState.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    if (currentPath == name) {
      currentState.pop();
    }
  }
}
