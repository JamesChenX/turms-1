import 'package:flutter/widgets.dart';

import 'chat_page_body.dart';
import 'chat_page_footer/chat_page_footer.dart';
import 'chat_page_header.dart';
import 'sub_navigation_rail/sub_navigation_rail.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    right:
                        BorderSide(color: Color.fromARGB(255, 213, 213, 213)))),
            width: 250,
            child: const SubNavigationRail(),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 245, 245, 245),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 64,
                  //   child: MessagePaneHeader(),
                  // ),
                  Container(
                    height: 64,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color.fromARGB(255, 231, 231, 231)))),
                    child: const ChatPageHeader(),
                  ),
                  const Expanded(child: ChatPageBody()),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 240),
                    child: ChatPageFooter(),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}