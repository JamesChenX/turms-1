import 'dart:ui';

import 'package:flutter/widgets.dart';

class AppUtils {
  AppUtils._();

  static Future<void> close() async {
    // Use "cancelable" to notify listeners.
    await WidgetsBinding.instance.exitApplication(AppExitType.cancelable);
    // Use "required" to force exit.
    await WidgetsBinding.instance.exitApplication(AppExitType.required);
    // Don't use "windowManager.close()" because it is force-quit the app.
  }
}
