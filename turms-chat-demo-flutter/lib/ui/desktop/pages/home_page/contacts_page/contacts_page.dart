import 'package:flutter/material.dart';

import '../../../../themes/index.dart';
import 'contact_profile_page/contact_profile_page.dart';
import 'sub_navigation_rail/sub_navigation_rail.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appThemeExtension = context.appThemeExtension;
    return Row(
      children: [
        _buildSubNavigationRail(appThemeExtension),
        _buildContactProfilePage(appThemeExtension),
      ],
    );
  }

  Widget _buildSubNavigationRail(AppThemeExtension appThemeExtension) =>
      SizedBox(
        width: Sizes.subNavigationRailWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      color: appThemeExtension.subNavigationRailDividerColor))),
          child: const SubNavigationRail(),
        ),
      );

  Widget _buildContactProfilePage(AppThemeExtension appThemeExtension) =>
      Expanded(
        child: ColoredBox(
          color: appThemeExtension.homePageBackgroundColor,
          child: const ContactProfilePage(),
        ),
      );
}
