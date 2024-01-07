import 'package:flutter/foundation.dart';
import 'package:tray_manager/tray_manager.dart';

import '../platform/platform_utils.dart';
import '../window/window_utils.dart';
import 'tray_menu_item.dart';

final class TrayUtils {
  TrayUtils._();

  static bool checkPlatformHasTray() => PlatformUtils.checkPlatforms(
      [TargetPlatform.linux, TargetPlatform.macOS, TargetPlatform.windows]);

  static Future<void> initTray(
      String tooltip, String icon, List<TrayMenuItem> menuItems) async {
    if (!checkPlatformHasTray()) {
      return;
    }
    await trayManager.setIcon(icon);
    await trayManager.setContextMenu(Menu(
        items: menuItems
            .map((item) => MenuItem(
                  key: item.key,
                  label: item.label,
                ))
            .toList()));
    await trayManager.setToolTip(tooltip);
    final keyToOnTap = <String, void Function()>{};
    for (final item in menuItems) {
      keyToOnTap[item.key] = item.onTap;
    }
    trayManager.addListener(_TrayListener(onTrayMenuItemTap: (item) {
      keyToOnTap[item.key]!.call();
    }));
  }
}

class _TrayListener extends TrayListener {
  final void Function(MenuItem menuItem) onTrayMenuItemTap;

  _TrayListener({required this.onTrayMenuItemTap});

  @override
  Future<void> onTrayIconMouseDown() async {
    await WindowUtils.show();
  }

  @override
  Future<void> onTrayIconRightMouseDown() async =>
      trayManager.popUpContextMenu();

  @override
  void onTrayMenuItemClick(MenuItem menuItem) => onTrayMenuItemTap(menuItem);
}