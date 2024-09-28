import 'package:flutter/widgets.dart';

import '../../../../themes/theme_config.dart';
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

  Widget _buildChatSessionPane() => ChatSessionPane();
}
