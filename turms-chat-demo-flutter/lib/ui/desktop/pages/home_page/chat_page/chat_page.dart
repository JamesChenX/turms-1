import 'package:flutter/widgets.dart';

import '../../../../themes/index.dart';
import 'chat_session_pane/chat_session_pane.dart';
import 'sub_navigation_rail/sub_navigation_rail.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSubNavigationRail(context.appThemeExtension),
          Expanded(child: _buildChatSessionPane()),
        ],
      );

  Widget _buildSubNavigationRail(AppThemeExtension appThemeExtension) =>
      SizedBox(
        width: Sizes.subNavigationRailWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      color: appThemeExtension.subNavigationRailDividerColor))),
          child: const SubNavigationRail(),
        ),
      );

  Widget _buildChatSessionPane() => ChatSessionPane();
}
