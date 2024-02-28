import 'package:flutter/widgets.dart';

import '../../../themes/theme_config.dart';
import 'chat_session_pane/chat_session_pane.dart';
import 'sub_navigation_rail/sub_navigation_rail.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSubNavigationRail(),
          Expanded(child: _buildChatSessionPane()),
        ],
      );

  Widget _buildSubNavigationRail() => Container(
        decoration: const BoxDecoration(
            border: Border(
                right: BorderSide(
                    color: ThemeConfig.subNavigationRailDividerColor))),
        width: ThemeConfig.subNavigationRailWidth,
        child: const SubNavigationRail(),
      );

  Widget _buildChatSessionPane() => ChatSessionPane();
}
