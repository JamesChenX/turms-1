import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../l10n/app_localizations.dart';

class SubNavigationRail extends StatelessWidget {
  const SubNavigationRail({super.key});

  @override
  Widget build(BuildContext context) {
    final mockItems = [
      '1 contact1',
      '2 contact3',
      '3 contact4',
      '4 contact5',
      '5 contact6',
      '6 contact7',
      '7 contact8',
      '8 contact9',
      '9 contact3',
      '10 contact3',
      'contact3',
    ];
    const backgroundColor = Color.fromARGB(255, 233, 233, 233);
    return ColoredBox(
        color: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: const Color.fromARGB(255, 247, 247, 247),
              alignment: Alignment.center,
              child: Container(
                // height: 26,
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).search,
                    filled: true,
                    fillColor: const Color.fromARGB(255, 226, 226, 226),
                    prefixIcon: const Icon(Symbols.search),
                    border: InputBorder.none,
                  ),
                ),
              ),
              // child: ,
            ),
            // Expanded(
            //     child: MediaQuery.removePadding(
            //         context: context,
            //         removeTop: true,
            //         removeLeft: true,
            //         removeRight: true,
            //         child: ListView.builder(
            //           padding: EdgeInsets.zero,
            //           itemCount: mockItems.length,
            //           prototypeItem: Conversation(
            //             contactName: '',
            //             backgroundColor:
            //             ThemeConfig.conversationBackgroundColor,
            //             hoverBackgroundColor:
            //             ThemeConfig.conversationBackgroundColor,
            //             onTap: () {},
            //           ),
            //           itemBuilder: (context, index) => Conversation(
            //             contactName: mockItems[index],
            //             backgroundColor: backgroundColor,
            //           ),
            //         )))
          ],
        ));
  }
}