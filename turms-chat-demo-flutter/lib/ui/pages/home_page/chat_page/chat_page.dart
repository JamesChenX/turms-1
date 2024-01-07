import 'package:flutter/widgets.dart';

import 'chat_session_pane/chat_session_pane.dart';
import 'sub_navigation_rail/sub_navigation_rail.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSubNavigationRail(),
          _buildChatSessionPane(),
        ],
      );

  Widget _buildSubNavigationRail() => Container(
        decoration: const BoxDecoration(
            border: Border(
                right: BorderSide(color: Color.fromARGB(255, 213, 213, 213)))),
        width: 250,
        child: const SubNavigationRail(),
      );

  Widget _buildChatSessionPane() => Expanded(child: ChatSessionPane());
}