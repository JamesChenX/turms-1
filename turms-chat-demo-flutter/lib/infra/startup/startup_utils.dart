import 'dart:io';

import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/app_config.dart';

const launchAtStartupArg = 'autostart';

class StartupUtils {
  StartupUtils._();

  /// Currently, only works for windows
  static Future<void> initEnableAutoStartAndOpenSettings(
      bool autoStartLaunchMinimized,
      [bool? isWindows]) async {
    // In case somebody don't use msix
    final packageInfo = await PackageInfo.fromPlatform();
    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
      args: [if (!autoStartLaunchMinimized) launchAtStartupArg],
    );

    // We just add this entry so we have the same behaviour like in msix
    if (!(await launchAtStartup.isEnabled())) {
      await launchAtStartup.enable();
      return;
    }

    // Can be linux on startup flag change
    if (isWindows ?? false) {
      // Ideally, we should configure it programmatically
      // The launch_at_startup package does not support this currently
      // See: https://learn.microsoft.com/en-us/uwp/api/Windows.ApplicationModel.StartupTask?view=winrt-22621
      await launchUrl(Uri.parse('ms-settings:startupapps'));
    }
  }

  static Future<void> initDisableAutoStart(
      bool autoStartLaunchMinimized) async {
    // In case somebody don't use msix
    launchAtStartup.setup(
      appName: AppConfig.packageInfo.appName,
      appPath: Platform.resolvedExecutable,
      args: [if (autoStartLaunchMinimized) launchAtStartupArg],
    );

    // We just add this entry so we have the same behaviour like in msix
    if (await launchAtStartup.isEnabled()) {
      await launchAtStartup.disable();
    }
  }

  static Future<bool> isLinuxLaunchAtStartEnabled() async {
    final desktopFile = File(
        '${Platform.environment['HOME']}/.config/autostart/${AppConfig.packageInfo.appName}.desktop');
    return desktopFile.exists();
  }
}