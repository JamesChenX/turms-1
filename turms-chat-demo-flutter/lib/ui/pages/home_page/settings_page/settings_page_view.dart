import 'package:flutter/material.dart';

import '../../../components/t_title_bar.dart';
import 'about_settings_page.dart';
import 'general_settings_page.dart';
import 'my_account_settings_page.dart';
import 'notifications_settings_page.dart';
import 'settings_page_controller.dart';
import 'sub_navigation_rail.dart';

class SettingsPageView extends StatelessWidget {
  SettingsPageView(this.settingsPageController);

  final SettingsPageController settingsPageController;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 550,
        height: 470,
        // color: Color.fromARGB(255, 245, 245, 245),
        child: Stack(
          children: [
            Row(
              children: [
                SubNavigationRail(onTabSelected: (index, tab) {
                  settingsPageController.selectTable(index);
                }),
                Expanded(
                  child: Container(
                    child: IndexedStack(
                      index: settingsPageController.selectedTabIndex,
                      children: [
                        // TODO: support network proxy
                        MyAccountSettingsPage(),
                        NotificationsSettingsPage(),
                        GeneralSettingsPage(),
                        AboutSettingsPage()
                      ],
                    ),
                  ),
                )
              ],
            ),
            const TTitleBar(
              backgroundColor: Color.fromARGB(255, 245, 245, 245),
              displayCloseOnly: true,
              popOnCloseTapped: true,
            )
          ],
        ),
      );
}