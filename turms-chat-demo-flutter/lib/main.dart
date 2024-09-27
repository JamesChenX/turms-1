import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'domain/app/models/app_settings.dart';
import 'domain/app/repositories/app_settings_repository.dart';
import 'domain/app/view_models/app_settings_view_model.dart';
import 'domain/user/repositories/user_login_info_repository.dart';
import 'domain/user/view_models/user_login_infos_view_model.dart';
import 'domain/window/view_models/window_maximized_view_model.dart';
import 'infra/app/app_config.dart';
import 'infra/assets/assets.gen.dart';
import 'infra/autostart/autostart_manager.dart';
import 'infra/env/env_vars.dart';
import 'infra/exception/exception_extensions.dart';
import 'infra/logging/logger.dart';
import 'infra/media/video_utils.dart';
import 'infra/platform/platform_helpers.dart';
import 'infra/rpc/rpc_client.dart';
import 'infra/rpc/rpc_server.dart';
import 'infra/rust/frb_generated.dart';
import 'infra/tray/tray_menu_item.dart';
import 'infra/tray/tray_utils.dart';
import 'infra/window/window_event_listener.dart';
import 'infra/window/window_utils.dart';
import 'ui/desktop/pages/app.dart';

const appTypeNotification = 'notification';
const notificationWindowWidth = 200.0;
const notificationWindowHeight = 100.0;
WindowController? notificationWindowController;

Future<void> main(List<String> args) async {
  try {
    await run(args);
  } catch (e, s) {
    logger.error(e.toString(), e, s);
    // TODO: i10n
    final text = e is Exception ? e.message : e.toString();
    await FlutterPlatformAlert.showAlert(
        windowTitle: 'Could not launch "${EnvVars.windowTitle}"',
        text: text,
        iconStyle: IconStyle.error,
        options: PlatformAlertOptions(
            windows: WindowsAlertOptions(preferMessageBox: true)));
    // Ensure all logs are flushed before exit.
    scheduleMicrotask(() {
      exit(1);
    });
  }
}

Future<void> run(List<String> args) async {
  // TODO: Enable other platforms when we have adapted and tested.
  if (!isDesktop) {
    throw Exception('Only desktop is supported currently');
  }
  WidgetsFlutterBinding.ensureInitialized();
  MaterialSymbolsBase.forceCompileTimeTreeShaking();

  FlutterError.onError = (FlutterErrorDetails details) {
    logger.error('Caught a Flutter error: $details');
  };

  if (args.contains(appTypeNotification)) {
    // await runAsNotification();
  } else {
    await WindowUtils.ensureInitialized();
    await runAsMainApp(args);
  }
}

Future<void> runAsMainApp(List<String> args) async {
  if (kReleaseMode) {
    // logger.addAppender((event) {
    //   if (event.level.value <= Level.error.value) {
    //     // TODO: Send error logs to servers
    //   }
    // });
  } else if (kDebugMode) {
    debugInvertOversizedImages = true;
    // only uncomment when needed because it effects the performance.
    // FocusManager.instance.addListener(() {
    //   logger.d('The primary focus has changed: ${debugDescribeFocusTree()}');
    // });
  }

  logger.warn('The application is still incubating, '
      'meaning we will make incompatible changes without migration support, '
      'such as database schema changes');

  await AppConfig.load();
  await RustLib.init();
  logger
    ..info(
        'The directory info: the application directory: ${AppConfig.appDir}, the temporary directory: ${AppConfig.tempDir}')
    ..info('The application package info: ${AppConfig.packageInfo}');

  VideoUtils.ensureInitialized();

  final container = ProviderContainer();
  await _initForDesktopPlatforms(args, container);
  await _loadAppSettings(container);

  // await WindowUtils.createDialog(
  //     appTypeNotification, notificationWindowWidth, notificationWindowHeight);
  runApp(UncontrolledProviderScope(
      container: container, child: App(container: container)));
}

Future<void> _loadAppSettings(ProviderContainer container) async {
  final appSettings = await appSettingsRepository.selectAll();
  container.read(appSettingsViewModel.notifier).state =
      AppSettings.fromTableData(appSettings);

  final userLoginInfos = await userLoginInfoRepository.selectUserLoginInfos();
  container.read(userLoginInfosViewModel.notifier).state = userLoginInfos;
}

Future<void> _initForDesktopPlatforms(
    List<String> args, ProviderContainer container) async {
  if (args.contains('daemon')) {
    await RpcClient.connect();
  } else {
    final rpcServer = await RpcServer.create();
    WidgetsBinding.instance
        .addObserver(AppLifecycleListener(onExitRequested: () async {
      try {
        await notificationWindowController?.close();
        await rpcServer.close();
      } catch (e) {
        // ignore
      }
      return AppExitResponse.exit;
    }));
  }

  initAutostartManager(
      appName: AppConfig.packageInfo.appName,
      appPath: Platform.resolvedExecutable,
      args: []);

  // UI-related

  WindowUtils.addListener(WindowEventListener(onMaximize: () {
    container.read(isWindowMaximizedViewModel.notifier).state = true;
  }, onUnmaximize: () {
    container.read(isWindowMaximizedViewModel.notifier).state = false;
  }));

  // Note that we need to setup window before painting,
  // otherwise UI will jitter.
  await WindowUtils.setupWindow(
      minimumSize: AppConfig.defaultWindowSizeForLoginScreen,
      size: AppConfig.defaultWindowSizeForLoginScreen,
      backgroundColor: Colors.transparent,
      title: AppConfig.title);
  try {
    await TrayUtils.initTray(
        AppConfig.title,
        // TODO: use ico to display
        Assets.images.iconPng.path,
        [
          TrayMenuItem(key: 'exit', label: 'Exit', onTap: () => exit(0)),
        ]);
  } catch (e) {
    logger.warn('Failed to init the tray: $e');
  }
}