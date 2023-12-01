import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turms_chat_demo/ui/pages/home_page/settings_page/settings_page.dart';

import '../../../../infra/io/global_keyboard_listener.dart';
import 'settings_page_view.dart';

class SettingsPageController extends State<SettingsPage> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) => GlobalKeyboardListener(
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          final name = ModalRoute.of(context)?.settings.name;
          if (name == settingsDialogRouteName) {
            Navigator.pop(context);
            return true;
          }
        }
        return false;
      },
      child: SettingsPageView(this));

  void selectTable(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }
}