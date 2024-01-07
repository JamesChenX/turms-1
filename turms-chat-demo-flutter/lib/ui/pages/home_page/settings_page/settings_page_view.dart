import 'package:flutter/material.dart';

import '../../../components/t_title_bar.dart';
import '../../../themes/theme_config.dart';
import 'settings_page_controller.dart';
import 'settings_pane.dart';
import 'sub_navigation_rail.dart';

class SettingsPageView extends StatelessWidget {
  const SettingsPageView(this.settingsPageController);

  final SettingsPageController settingsPageController;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: ThemeConfig.dialogWidthMedium,
        height: ThemeConfig.dialogHeightMedium,
        // color: ThemeConfig.homePageBackgroundColor,
        child: Stack(
          children: [
            Row(
              children: [
                SubNavigationRail(onTabSelected: (index, tab) {
                  settingsPageController.selectTab(index, tab);
                }),
                const Expanded(
                  child: SettingsPane(),
                ),
              ],
            ),
            const TTitleBar(
              backgroundColor: ThemeConfig.homePageBackgroundColor,
              displayCloseOnly: true,
              popOnCloseTapped: true,
            )
          ],
        ),
      );
}