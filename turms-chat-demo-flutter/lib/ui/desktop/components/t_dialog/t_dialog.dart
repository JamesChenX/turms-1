import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../themes/theme_config.dart';
import '../t_title_bar/t_title_bar.dart';

const config = FadeScaleTransitionConfiguration(
  barrierColor: Colors.transparent,
  barrierDismissible: false,
);

const routeSettingsArguments = Object();

bool isTDialogRoute(Route<dynamic> route) =>
    route.settings.arguments == routeSettingsArguments;

Future<void> showCustomTDialog(
        {required String routeName,
        required BuildContext context,
        BorderRadiusGeometry borderRadius = ThemeConfig.borderRadius4,
        required Widget child}) =>
    showModal(
        routeSettings:
            RouteSettings(name: routeName, arguments: routeSettingsArguments),
        context: context,
        configuration: config,
        builder: (BuildContext context) => Align(
              child: Material(
                borderRadius: borderRadius,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: borderRadius,
                        boxShadow: ThemeConfig.boxShadow),
                    child: RepaintBoundary(child: child)),
              ),
            ));

Future<void> showSimpleTDialog(
        {required String routeName,
        required BuildContext context,
        double? width,
        double? height,
        required Widget child}) =>
    showCustomTDialog(
        context: context,
        routeName: routeName,
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? _) => SizedBox(
            width: width ?? ThemeConfig.dialogWidthMedium,
            height: height ?? ThemeConfig.dialogHeightMedium,
            child: Stack(
              children: [
                Positioned.fill(
                  child: child,
                ),
                const TTitleBar(
                  backgroundColor: Colors.transparent,
                  displayCloseOnly: true,
                  popOnCloseTapped: true,
                )
              ],
            ),
          ),
        ));