import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'window_event_listener.dart';

class WindowUtils {
  WindowUtils._();

  static Future<void> close() async => windowManager.close();

  static Future<void> maximize() => windowManager.maximize();

  static Future<void> unmaximize() => windowManager.unmaximize();

  static Future<bool> isMaximized() => windowManager.isMaximized();

  static Future<void> minimize() => windowManager.minimize();

  static Future<bool> isAlwaysOnTop() => windowManager.isAlwaysOnTop();

  static Future<void> setAlwaysOnTop(bool isAlwaysOnTop) =>
      windowManager.setAlwaysOnTop(isAlwaysOnTop);

  static Future<void> show() => windowManager.show();

  static Future<void> hide() => windowManager.hide();

  static Future<void> ensureInitialized() => windowManager.ensureInitialized();

  static Future<void> setupWindow(
      {required Size size,
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
}