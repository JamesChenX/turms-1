import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turms_chat_demo/ui/components/t_title_bar.dart';

import '../themes/theme_config.dart';

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
        required Widget child}) =>
    showModal(
        routeSettings:
            RouteSettings(name: routeName, arguments: routeSettingsArguments),
        context: context,
        configuration: config,
        builder: (BuildContext context) => Align(
              child: Material(
                borderRadius: ThemeConfig.borderRadius4,
                child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: ThemeConfig.borderRadius4,
                        boxShadow: ThemeConfig.boxShadow),
                    child: child),
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
                  backgroundColor: ThemeConfig.homePageBackgroundColor,
                  displayCloseOnly: true,
                  popOnCloseTapped: true,
                )
              ],
            ),
          ),
        ));
