import 'package:flutter/material.dart';

import 'tabs.dart';
import 'user_profile_popup.dart';

class MainNavigationRail extends StatelessWidget {
  const MainNavigationRail({super.key});

  @override
  Widget build(BuildContext context) => Container(
      color: const Color.fromARGB(255, 46, 46, 46),
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: const Column(
        children: [
          UserProfilePopup(),
          SizedBox(
            height: 24,
          ),
          Expanded(child: Tabs())
        ],
      ));
}