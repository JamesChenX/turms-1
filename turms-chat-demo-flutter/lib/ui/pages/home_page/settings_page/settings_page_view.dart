import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../components/components.dart';
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
        child: Row(
          children: [
            SubNavigationRail(onTabSelected: settingsPageController.selectTab),
            Expanded(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: TTitleBar(
                      backgroundColor: ThemeConfig.homePageBackgroundColor,
                      displayCloseOnly: true,
                      popOnCloseTapped: true,
                      usePositioned: false,
                    ),
                  ),
                  Expanded(
                      child: SettingsPane(
                    onSettingFormFieldGroupScrolled:
                        settingsPageController.selectTabWithoutScroll,
                  )),
                ],
              ),
            ),
          ],
        ),
      );
}
