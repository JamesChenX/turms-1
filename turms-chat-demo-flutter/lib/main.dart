import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'domain/app/models/app_settings.dart';
import 'domain/app/repositories/app_settings_repository.dart';
import 'domain/app/view_models/app_settings_view_model.dart';
import 'domain/user/repositories/user_login_info_repository.dart';
import 'domain/user/view_models/user_login_infos_view_model.dart';
import 'domain/window/view_models/window_maximized_view_model.dart';
import 'infra/app/app_config.dart';
import 'infra/logging/logger.dart';
import 'infra/platform/platform_helpers.dart';
import 'infra/window/window_event_listener.dart';
import 'infra/window/window_utils.dart';
import 'ui/pages/app.dart';

Future<void> main() async {
  // TODO: Enable other platforms when we have adapted and tested.
  if (!isDesktop) {
    throw Exception('Only desktop is supported currently');
  }

  WidgetsFlutterBinding.ensureInitialized();

  logger.w('The application is still incubating, '
      'meaning we will make incompatible changes without migration support, '
      'such as database schema changes');

  MaterialSymbolsBase.forceCompileTimeTreeShaking();

  final container = ProviderContainer();

  await WindowUtils.ensureInitialized();
  WindowUtils.addListener(WindowEventListener(onMaximize: () {
    container.read(isWindowMaximizedViewModel.notifier).state = true;
  }, onUnmaximize: () {
    container.read(isWindowMaximizedViewModel.notifier).state = false;
  }));

  final appSettings = await appSettingsRepository.selectAll();
  container.read(appSettingsViewModel.notifier).state =
      AppSettings.fromTableData(appSettings);

  final userLoginInfos = await userLoginInfoRepository.selectUserLoginInfos();
  container.read(userLoginInfosViewModel.notifier).state = userLoginInfos;

  // Note that we need to setup window before painting,
  // otherwise UI will jitter.
  await WindowUtils.setupWindow(
      size: AppConfig.defaultWindowSizeBeforeLogin,
      backgroundColor: Colors.transparent,
      title: AppConfig.title);
  runApp(UncontrolledProviderScope(container: container, child: App()));
}