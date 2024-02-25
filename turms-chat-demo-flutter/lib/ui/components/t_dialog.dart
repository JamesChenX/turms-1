import 'package:animations/animations.dart';
import 'package:pixel_snap/material.dart';

import '../themes/theme_config.dart';

const config = FadeScaleTransitionConfiguration(
  barrierColor: Colors.transparent,
  barrierDismissible: false,
);

const routeSettingsArguments = Object();

bool isTDialogRoute(Route<dynamic> route) =>
    route.settings.arguments == routeSettingsArguments;

Future<void> showTDialog(
        BuildContext context, String routeName, Widget child) =>
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
