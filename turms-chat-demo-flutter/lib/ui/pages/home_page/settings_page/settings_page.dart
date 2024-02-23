import 'package:flutter/material.dart';

import '../../../components/t_dialog.dart';
import 'settings_page_controller.dart';

/// UI design: We don't put all settings separated by groups in one view because:
/// 1. It seems messy.
/// 2. (James Chen) my mouse wheel always break in just few months after I bought them,
/// which make me avoiding designing scrollable UI.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageController();
}

Future<void> showSettingsDialog(BuildContext context) =>
    showTDialog(context, '/settings-dialog', const SettingsPage());
