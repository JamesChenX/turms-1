import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../themes/theme_config.dart';
import '../t_circle.dart';
import 't_toast_type.dart';
import 't_toast_view.dart';

class TToast {
  TToast._();

  static OverlayState? _overlayState;
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static Future<void> showToast(
    BuildContext context,
    String text, {
    Duration toastDuration = const Duration(seconds: 3),
    TToastType type = TToastType.info,
  }) async {
    // TODO: support displaying multiple toasts at the same time.
    dismiss();
    _overlayState = Overlay.of(context);

    final Widget toastChild = TToastView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: ThemeConfig.borderRadius8,
          boxShadow: ThemeConfig.boxShadow,
          // border,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            switch (type) {
              TToastType.info => const TCircle(
                  backgroundColor: ThemeConfig.info,
                  child: Icon(
                    Symbols.info_i_rounded,
                    color: Colors.white,
                    size: 14,
                  )),
              TToastType.success => const TCircle(
                  backgroundColor: ThemeConfig.success,
                  child: Icon(
                    Symbols.done_rounded,
                    color: Colors.white,
                    size: 14,
                  )),
              TToastType.error => const TCircle(
                  backgroundColor: ThemeConfig.error,
                  child: Icon(
                    Symbols.close_rounded,
                    color: Colors.white,
                    size: 14,
                  )),
              TToastType.warning => const TCircle(
                  backgroundColor: ThemeConfig.warning,
                  child: Icon(
                    Symbols.priority_high_rounded,
                    color: Colors.white,
                    size: 14,
                  )),
            },
            const SizedBox(
              width: 8,
            ),
            Text(text, softWrap: true, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
      duration: toastDuration,
      onDismissed: dismiss,
    );

    _overlayEntry = OverlayEntry(
        builder: (BuildContext context) =>
            Positioned(bottom: 60, left: 18, right: 18, child: toastChild));

    _isVisible = true;
    _overlayState!.insert(_overlayEntry!);
  }

  static void dismiss() {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}