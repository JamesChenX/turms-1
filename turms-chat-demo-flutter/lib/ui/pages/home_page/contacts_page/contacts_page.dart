import 'package:flutter/material.dart';

import '../../../themes/theme_config.dart';
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

  Container _buildSubNavigationRail() => Container(
        decoration: const BoxDecoration(
            border: Border(
                right: BorderSide(color: Color.fromARGB(255, 213, 213, 213)))),
        width: 250,
        child: const SubNavigationRail(),
      );

  Expanded _buildContactProfilePage() => Expanded(
        child: Container(
          color: ThemeConfig.homePageBackgroundColor,
          child: const ContactProfilePage(),
        ),
      );
}