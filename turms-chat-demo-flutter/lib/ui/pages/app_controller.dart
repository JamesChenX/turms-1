import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../domain/window/view_models/window_maximized_view_model.dart';
import '../../infra/app/app_config.dart';
import '../../infra/window/window_utils.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_localizations_view_model.dart';
import 'app.dart';
import 'app_view.dart';

class AppController extends ConsumerState<App> with WindowListener {
  // Used to avoiding unnecessary rebuilds and preserve children's states
  // across multiple builds when minimizing and maximizing.
  final homePageKey = GlobalKey();

  bool shouldDisplayLoginPage = true;
  bool isDisplayingLoginPage = true;
  late bool isWindowMaximized;
  bool isWindowSettingUp = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appLocalizationsViewModel.notifier).state =
          lookupAppLocalizations(
              WidgetsBinding.instance.platformDispatcher.locale);
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
    final displayLoginPage = ref.watch(loggedInUserInfoViewModel) == null;
    if (shouldDisplayLoginPage != displayLoginPage && !isWindowSettingUp) {
      _hideAndResize(displayLoginPage).then((value) {
        setState(() {
          shouldDisplayLoginPage = displayLoginPage;
        });
        SchedulerBinding.instance.addPostFrameCallback((_) {
          WindowUtils.show();
        });
      });
    }
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
      await WindowUtils.setupWindow(
          size: AppConfig.defaultWindowSizeBeforeLogin,
          backgroundColor: Colors.transparent);
    } else {
      await WindowUtils.setupWindow(
          minimumSize: AppConfig.minWindowSizeAfterLogin,
          size: AppConfig.defaultWindowSizeAfterLogin,
          resizable: true,
          backgroundColor: Colors.white);
    }
    isWindowSettingUp = true;
  }
}