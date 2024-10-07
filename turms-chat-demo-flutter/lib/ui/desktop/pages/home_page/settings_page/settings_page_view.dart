import 'package:flutter/material.dart';

import '../../../../themes/index.dart';

import '../../../components/index.dart';
import 'settings_page_controller.dart';
import 'settings_pane.dart';
import 'sub_navigation_rail.dart';

class SettingsPageView extends StatelessWidget {
  const SettingsPageView(this.settingsPageController);

  final SettingsPageController settingsPageController;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: Sizes.dialogWidthMedium,
        height: Sizes.dialogHeightMedium,
        child: Row(
          children: [
            SubNavigationRail(onTabSelected: settingsPageController.selectTab),
            Expanded(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: TTitleBar(
                      backgroundColor: Colors.transparent,
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
