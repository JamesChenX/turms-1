import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:turms_chat_demo/ui/pages/home_page/settings_page/settings_pane.dart';
import 'package:turms_chat_demo/ui/pages/home_page/settings_page/sub_navigation_rail.dart';

import '../../../components/components.dart';
import '../../../themes/theme_config.dart';
import 'settings_page_controller.dart';

class SettingsPageView extends StatelessWidget {
  const SettingsPageView(this.settingsPageController);

  final SettingsPageController settingsPageController;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: ThemeConfig.dialogWidthMedium,
        height: ThemeConfig.dialogHeightMedium,
        // color: ThemeConfig.homePageBackgroundColor,
        child: Row(
          children: [
            SubNavigationRail(onTabSelected: settingsPageController.selectTab),
            const Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TTitleBar(
                      backgroundColor: ThemeConfig.homePageBackgroundColor,
                      displayCloseOnly: true,
                      popOnCloseTapped: true,
                      usePositioned: false,
                    ),
                  ),
                  Expanded(child: SettingsPane()),
                ],
              ),
            ),
          ],
        ),
      );
}