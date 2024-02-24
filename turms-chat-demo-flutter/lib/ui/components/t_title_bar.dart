import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/user/models/setting_action_on_close.dart';
import '../../domain/user/view_models/user_settings_view_model.dart';
import '../../domain/window/view_models/window_maximized_view_model.dart';
import '../../infra/ui/color_extensions.dart';
import '../../infra/window/window_utils.dart';
import '../l10n/app_localizations.dart';
import '../l10n/view_models/app_localizations_view_model.dart';
import '../themes/theme_config.dart';
import 't_button/t_icon_button.dart';

class TTitleBar extends ConsumerStatefulWidget {
  const TTitleBar(
      {super.key,
      this.displayCloseOnly = false,
      this.popOnCloseTapped = false,
      this.usePositioned = true,
      required this.backgroundColor});

  final bool displayCloseOnly;
  final bool popOnCloseTapped;
  final bool usePositioned;
  final Color backgroundColor;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TTitleBarState();
}

class _TTitleBarState extends ConsumerState<TTitleBar> {
  bool _isAlwaysOnTop = false;

  @override
  Widget build(BuildContext context) {
    final localizations = ref.watch(appLocalizationsViewModel);
    final child = widget.displayCloseOnly
        ? buildCloseButton(context, localizations)
        : Row(children: [
            buildSetAlwaysOnTopButton(localizations),
            buildMinimizeButton(localizations),
            buildMaximizeButton(localizations),
            buildCloseButton(context, localizations),
          ]);
    return widget.usePositioned
        ? Positioned(top: 0, right: 0, child: child)
        : child;
  }

  TIconButton buildSetAlwaysOnTopButton(AppLocalizations localizations) =>
      TIconButton(
          size: ThemeConfig.titleBarSize,
          color: _isAlwaysOnTop
              ? widget.backgroundColor.darken()
              : widget.backgroundColor,
          hoverColor: const Color.fromARGB(255, 226, 226, 226),
          iconData: Symbols.push_pin,
          iconSize: 16,
          iconColor: _isAlwaysOnTop
              ? ThemeConfig.primary
              : const Color.fromARGB(255, 67, 67, 67),
          onTap: () async {
            setState(() => _isAlwaysOnTop = !_isAlwaysOnTop);
            await WindowUtils.setAlwaysOnTop(_isAlwaysOnTop);
          },
          tooltip: _isAlwaysOnTop
              ? localizations.alwaysOnTopDisable
              : localizations.alwaysOnTopEnable);

  TIconButton buildMinimizeButton(AppLocalizations localizations) =>
      TIconButton(
          size: ThemeConfig.titleBarSize,
          color: widget.backgroundColor,
          hoverColor: const Color.fromARGB(255, 226, 226, 226),
          iconData: Symbols.horizontal_rule,
          iconSize: 16,
          iconColor: const Color.fromARGB(255, 67, 67, 67),
          onTap: WindowUtils.minimize,
          tooltip: localizations.minimize);

  TIconButton buildMaximizeButton(AppLocalizations localizations) {
    final isWindowMaximized = ref.watch(isWindowMaximizedViewModel);
    return TIconButton(
      size: ThemeConfig.titleBarSize,
      color: widget.backgroundColor,
      hoverColor: const Color.fromARGB(255, 226, 226, 226),
      iconData: isWindowMaximized ? Symbols.stack : Symbols.crop_square_rounded,
      iconSize: 16,
      iconColor: const Color.fromARGB(255, 67, 67, 67),
      iconFlipX: isWindowMaximized,
      onTap: () async {
        if (isWindowMaximized) {
          await WindowUtils.unmaximize();
        } else {
          await WindowUtils.maximize();
        }
      },
      tooltip:
          isWindowMaximized ? localizations.restore : localizations.maximize,
    );
  }

  TIconButton buildCloseButton(
          BuildContext context, AppLocalizations localizations) =>
      TIconButton(
        size: ThemeConfig.titleBarSize,
        color: widget.backgroundColor,
        hoverColor: Colors.red,
        iconData: Symbols.close,
        iconSize: 16,
        iconColor: const Color.fromARGB(255, 67, 67, 67),
        iconHoverColor: Colors.white,
        tooltip: localizations.close,
        onTap: widget.popOnCloseTapped
            ? () => Navigator.of(context).pop()
            : () => switch (ref.read(userSettingsViewModel)?.actionOnClose ??
                    SettingActionOnClose.exit) {
                  SettingActionOnClose.minimizeToTray => WindowUtils.hide(),
                  SettingActionOnClose.exit => WindowUtils.close(),
                },
      );
}
