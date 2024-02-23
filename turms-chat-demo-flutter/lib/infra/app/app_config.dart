import 'dart:io';
import 'dart:ui';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../env/env_vars.dart';

class AppConfig {
  AppConfig._();

  static const title = EnvVars.windowTitle;

  static const defaultWindowSizeBeforeLogin = Size(480, 450);

  static const defaultWindowSizeAfterLogin = Size(960, 640);
  static const minWindowSizeAfterLogin = Size(700, 640);

  static late PackageInfo packageInfo;

  static late String appDir;

  static Future<void> load() async {
    packageInfo = await PackageInfo.fromPlatform();
    final appDocDir = await getApplicationDocumentsDirectory();
    appDir =
        '${appDocDir.path}${Platform.pathSeparator}${AppConfig.packageInfo.packageName}';
  }
}
