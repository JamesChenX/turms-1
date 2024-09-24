import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_size/window_size.dart';

import 'window_event_listener.dart';

class WindowUtils {
  WindowUtils._();

  static Future<void> maximize() => windowManager.maximize();

  static Future<void> unmaximize() => windowManager.unmaximize();

  static Future<bool> isMaximized() => windowManager.isMaximized();

  static Future<void> minimize() => windowManager.minimize();

  static Future<bool> isAlwaysOnTop() => windowManager.isAlwaysOnTop();

  static Future<void> setAlwaysOnTop(bool isAlwaysOnTop) =>
      windowManager.setAlwaysOnTop(isAlwaysOnTop);

  static Future<bool> isVisible() => windowManager.isVisible();

  static Future<void> show({bool focus = true}) async {
    await windowManager.show();
    if (focus) {
      await windowManager.focus();
    }
  }

  static Future<void> hide() => windowManager.hide();

  static Future<void> focus() async => windowManager.focus();

  static Future<void> ensureInitialized() => windowManager.ensureInitialized();

  static Future<void> setupWindow(
      {Size? size,
      Size? minimumSize,
      bool resizable = false,
      Color? backgroundColor,
      String? title}) async {
    await windowManager.waitUntilReadyToShow(WindowOptions(
        minimumSize: minimumSize,
        size: size,
        backgroundColor: Colors.transparent,
        center: true,
        titleBarStyle: TitleBarStyle.hidden,
        skipTaskbar: false,
        title: title));
    if (backgroundColor != null) {
      await windowManager.setBackgroundColor(backgroundColor);
    }
    await windowManager.setAsFrameless();
    await windowManager.setResizable(resizable);
    await windowManager.setHasShadow(true);
  }

  static Future<void> startDragging() => windowManager.startDragging();

  static bool hasListeners() => windowManager.hasListeners;

  static void addListener(WindowListener listener) {
    windowManager.addListener(listener);
  }

  static void removeListener(WindowEventListener listener) {
    windowManager.removeListener(listener);
  }

  static Future<void> setSkipTaskbar(bool skip) async =>
      windowManager.setSkipTaskbar(skip);

  static Future<WindowController> createDialog(
      String arguments, double width, double height) async {
    final controller = await DesktopMultiWindow.createWindow(arguments);
    final screen = await getCurrentScreen();
    await controller.showTitleBar(false);
    await controller.setPreventClose(true);
    // TODO: https://github.com/rustdesk-org/rustdesk_desktop_multi_window/pull/19
    // await controller.resizable(false);
    if (screen == null) {
      await controller.setFrame(Rect.fromLTWH(0, 0, width, height));
    } else {
      await controller.setFrame(Rect.fromLTWH(screen.visibleFrame.width - width,
          screen.visibleFrame.height - height, width, height));
    }
    await controller.show();
    return controller;
  }
}