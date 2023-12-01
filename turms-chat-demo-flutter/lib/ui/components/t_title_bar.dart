import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/window/view_models/window_maximized_view_model.dart';
import '../../infra/window/window_utils.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_localizations_view_model.dart';
import 't_icon_button.dart';

class TTitleBar extends ConsumerStatefulWidget {
  const TTitleBar(
      {super.key,
      this.displayCloseOnly = false,
      this.popOnCloseTapped = false,
      required this.backgroundColor});

  final bool displayCloseOnly;
  final bool popOnCloseTapped;
  final Color backgroundColor;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TTitleBarState();
}

class _TTitleBarState extends ConsumerState<TTitleBar> {
  bool _isAlwaysOnTop = false;

  @override
  Widget build(BuildContext context) {
    final localizations = ref.read(appLocalizationsViewModel);
    final child = widget.displayCloseOnly
        ? buildCloseButton(context, localizations)
        : Row(children: [
            buildSetAlwaysOnTopButton(localizations),
            buildMinimizeButton(localizations),
            buildMaximizeButton(localizations),
            buildCloseButton(context, localizations),
          ]);
    return Positioned(top: 0, right: 0, child: child);
  }

  TIconButton buildSetAlwaysOnTopButton(AppLocalizations localizations) =>
      TIconButton(
          size: const Size(36, 28),
          color: widget.backgroundColor,
          hoverColor: const Color.fromARGB(255, 226, 226, 226),
          iconData: Symbols.push_pin,
          iconSize: 16,
          onPressed: () async {
            setState(() => _isAlwaysOnTop = !_isAlwaysOnTop);
            await WindowUtils.setAlwaysOnTop(_isAlwaysOnTop);
          },
          tooltip: _isAlwaysOnTop
              ? localizations.alwaysOnTopDisable
              : localizations.alwaysOnTopEnable);

  TIconButton buildMinimizeButton(AppLocalizations localizations) =>
      TIconButton(
          size: const Size(36, 28),
          color: widget.backgroundColor,
          hoverColor: const Color.fromARGB(255, 226, 226, 226),
          iconData: Symbols.horizontal_rule,
          iconSize: 16,
          iconColor: const Color.fromARGB(255, 67, 67, 67),
          onPressed: WindowUtils.minimize,
          tooltip: localizations.minimize);

  TIconButton buildMaximizeButton(AppLocalizations localizations) {
    final isWindowMaximized = ref.watch(isWindowMaximizedViewModel);
    return TIconButton(
      size: const Size(36, 28),
      color: widget.backgroundColor,
      hoverColor: const Color.fromARGB(255, 226, 226, 226),
      iconData: isWindowMaximized ? Symbols.stack : Symbols.crop_square_rounded,
      iconSize: 16,
      iconColor: const Color.fromARGB(255, 67, 67, 67),
      iconFlipX: isWindowMaximized,
      onPressed: () async {
        if (isWindowMaximized) {
          await WindowUtils.unmaximize();
        } else {
          await WindowUtils.maximize();
        }
      },
      tooltip:
          isWindowMaximized ? localizations.restore : localizations.maximize,
      // style: _buttonStyle,
      // color: ThemeConfig.titleBarColor,
      // icon: const Icon(
      //   Symbols.square_outlined,
      //   size: 16,
      //   color: Color.fromARGB(255, 67, 67, 67),
    );
  }

  TIconButton buildCloseButton(
          BuildContext context, AppLocalizations localizations) =>
      TIconButton(
        size: const Size(36, 28),
        color: widget.backgroundColor,
        hoverColor: Colors.red,
        iconData: Symbols.close,
        iconSize: 16,
        iconColor: const Color.fromARGB(255, 67, 67, 67),
        iconHoverColor: Colors.white,
        tooltip: localizations.close,
        onPressed: widget.popOnCloseTapped
            ? () => Navigator.of(context).pop()
            : WindowUtils.close,
      );
}