import 'package:flutter/material.dart';

import 'settings_page_controller.dart';

/// UI design: We don't put all settings sepreted by groups in one view because:
/// 1. It seems messy.
/// 2. (James Chen) my mouse wheel always break in just few months after I bought them,
/// which make me avoiding designing scrollable UI.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageController();
}

const settingsDialogRouteName = '/settings-dialog';

Future<void> showSettingsDialog(BuildContext context) => showGeneralDialog(
    routeSettings: const RouteSettings(name: settingsDialogRouteName),
    context: context,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 100),
    barrierDismissible: false,
    pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        Align(
          child: Material(
            borderRadius: BorderRadius.circular(4),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(1.0, 1.0),
                        blurRadius: 6.0,
                      ),
                    ]),
                child: const SettingsPage()),
          ),
        ));