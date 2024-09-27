import 'package:flutter/material.dart';

import '../../../../themes/theme_config.dart';
import 'contact_profile_page/contact_profile_page.dart';
import 'sub_navigation_rail/sub_navigation_rail.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          _buildSubNavigationRail(),
          _buildContactProfilePage(),
        ],
      );

  Widget _buildSubNavigationRail() => const SizedBox(
        width: ThemeConfig.subNavigationRailWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      color: ThemeConfig.subNavigationRailDividerColor))),
          child: SubNavigationRail(),
        ),
      );

  Widget _buildContactProfilePage() => const Expanded(
        child: ColoredBox(
          color: ThemeConfig.homePageBackgroundColor,
          child: ContactProfilePage(),
        ),
      );
}