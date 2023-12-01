import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/t_title_bar.dart';
import 'chat_page/chat_page.dart';
import 'contacts_page/contacts_page.dart';
import 'files_page/files_page.dart';
import 'home_page_tab.dart';
import 'main_navigation_rail/main_navigation_rail.dart';
import 'shared_states/shared_states.dart';

class HomePageLandscape extends ConsumerStatefulWidget {
  const HomePageLandscape({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePageLandscape> createState() => _HomePageLandscapeState();
}

class _HomePageLandscapeState extends ConsumerState<HomePageLandscape> {
  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(homePageTabProvider);
    return Stack(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 56,
              child: MainNavigationRail(),
            ),
            Expanded(
                // child: IndexedStack(
                child: IndexedStack(
              index: switch (tab) {
                HomePageTab.chat => 0,
                HomePageTab.contacts => 1,
                HomePageTab.files => 2,
                // HomePageTab.settings => 3
              },
              children: [
                const ChatPage(),
                const ContactsPage(),
                const FilesPage(),
                // const SettingsPage(),
              ],
            ))
          ],
        ),
        const TTitleBar(backgroundColor: Color.fromARGB(255, 245, 245, 245)),
      ],
    );
  }
}