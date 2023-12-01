import 'package:flutter/material.dart';

import '../../../components/t_tabs.dart';
import '../../../themes/theme_config.dart';

class SubNavigationRail extends StatefulWidget {
  SubNavigationRail({super.key, required this.onTabSelected});

  final void Function(int, TTab) onTabSelected;

  @override
  State<SubNavigationRail> createState() => _SubNavigationRailState();
}

class _SubNavigationRailState extends State<SubNavigationRail> {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    right:
                        BorderSide(color: Color.fromARGB(255, 240, 240, 240)))),
            width: 140,
            // padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: ,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 24),
                  child: Text(
                      textAlign: TextAlign.start,
                      'Settings',
                      style: TextStyle(
                          fontSize: 16, color: ThemeConfig.secondaryTextColor)),
                ),
                TTabs(
                    tabs: [
                      TTab(id: 'myAccount', text: 'My Account'),
                      TTab(id: 'notification', text: 'Notification'),
                      TTab(id: 'general', text: 'General'),
                      TTab(id: 'about', text: 'About')
                    ],
                    onTabSelected: (index, tab) =>
                        widget.onTabSelected(index, tab)),
              ],
            ),
          ),
        ],
      );
}