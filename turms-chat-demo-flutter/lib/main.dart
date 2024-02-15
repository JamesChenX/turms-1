import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'domain/app/models/app_settings.dart';
import 'domain/app/repositories/app_settings_repository.dart';
import 'domain/app/view_models/app_settings_view_model.dart';
import 'domain/user/repositories/user_login_info_repository.dart';
import 'domain/user/view_models/user_login_infos_view_model.dart';
import 'domain/window/view_models/window_maximized_view_model.dart';
import 'infra/app/app_config.dart';
import 'infra/assets/assets.gen.dart';
import 'infra/logging/logger.dart';
import 'infra/media/video_utils.dart';
import 'infra/platform/platform_helpers.dart';
import 'infra/tray/tray_menu_item.dart';
import 'infra/tray/tray_utils.dart';
import 'infra/window/window_event_listener.dart';
import 'infra/window/window_utils.dart';
import 'ui/pages/app.dart';

Future<void> main() async {
  // TODO: Enable other platforms when we have adapted and tested.
  if (!isDesktop) {
    throw Exception('Only desktop is supported currently');
  }

  WidgetsFlutterBinding.ensureInitialized();

  if (kReleaseMode) {
    Logger.addLogListener((event) {
      if (event.level.value >= Level.error.value) {
        // TODO: Send error logs to servers
      }
    });
  } else if (kDebugMode) {
    debugInvertOversizedImages = true;
    // only uncomment when needed because it effects the performance.
    // FocusManager.instance.addListener(() {
    //   logger.d('The primary focus has changed: ${debugDescribeFocusTree()}');
    // });
  }

  logger.w('The application is still incubating, '
      'meaning we will make incompatible changes without migration support, '
      'such as database schema changes');

  MaterialSymbolsBase.forceCompileTimeTreeShaking();
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e('Caught a Flutter error: $details');
  };

  await AppConfig.load();
  VideoUtils.ensureInitialized();

  if (kDebugMode) {
    logger..d('The application directory: ${AppConfig.appDir}')..d(
        'The application package info: ${AppConfig.packageInfo}');
  }

  final container = ProviderContainer();

  await initForDesktopPlatforms(container);

  final appSettings = await appSettingsRepository.selectAll();
  container
      .read(appSettingsViewModel.notifier)
      .state =
      AppSettings.fromTableData(appSettings);

  final userLoginInfos = await userLoginInfoRepository.selectUserLoginInfos();
  container
      .read(userLoginInfosViewModel.notifier)
      .state = userLoginInfos;

  // Note that we need to setup window before painting,
  // otherwise UI will jitter.
  await WindowUtils.setupWindow(
      minimumSize: AppConfig.defaultWindowSizeBeforeLogin,
      size: AppConfig.defaultWindowSizeBeforeLogin,
      backgroundColor: Colors.transparent,
      title: AppConfig.title);
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}

Future<void> initForDesktopPlatforms(ProviderContainer container) async {
  await WindowUtils.ensureInitialized();
  WindowUtils.addListener(WindowEventListener(onMaximize: () {
    container
        .read(isWindowMaximizedViewModel.notifier)
        .state = true;
  }, onUnmaximize: () {
    container
        .read(isWindowMaximizedViewModel.notifier)
        .state = false;
  }));
  try {
    await TrayUtils.initTray(
        AppConfig.title,
        // TODO: use ico to display
        Assets.images.iconPng.path,
        [
          TrayMenuItem(key: 'exit', label: 'Exit', onTap: () => exit(0)),
        ]);
  } catch (e) {
    logger.w('Failed to init the tray: $e');
  }
}