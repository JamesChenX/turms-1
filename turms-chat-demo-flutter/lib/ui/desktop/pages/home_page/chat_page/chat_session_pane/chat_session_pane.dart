import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../themes/theme_config.dart';
import '../../../../components/index.dart';
import '../view_models/selected_conversation_view_model.dart';
import 'chat_session_details_drawer/chat_session_details_drawer.dart';
import 'chat_session_pane_body.dart';
import 'chat_session_pane_footer/chat_session_pane_footer.dart';
import 'chat_session_pane_header.dart';

const chatSessionDetailsDrawerGroupId = 'chatSessionDetailsDrawer';

class ChatSessionPane extends ConsumerWidget {
  ChatSessionPane({super.key});

  final TDrawerController drawerController = TDrawerController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedConversation = ref.watch(selectedConversationViewModel);
    if (selectedConversation == null) {
      return const ColoredBox(
        color: ThemeConfig.homePageBackgroundColor,
        child: TWindowControlZone(
            toggleMaximizeOnDoubleTap: true, child: TEmpty()),
      );
    }
    return ColoredBox(
      color: ThemeConfig.homePageBackgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: ThemeConfig.homePageHeaderHeight,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 231, 231, 231)))),
              child: ChatSessionPaneHeader(drawerController),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: ChatSessionPaneBody(selectedConversation)),
                    const _ChatSessionPaneFooter(),
                  ],
                ),
                TapRegion(
                    groupId: chatSessionDetailsDrawerGroupId,
                    onTapOutside: (event) {
                      drawerController.hide?.call();
                    },
                    child: RepaintBoundary(
                      child: TDrawer(
                          controller: drawerController,
                          child: ChatSessionDetailsDrawer(
                            conversation: selectedConversation,
                          )),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatSessionPaneFooter extends StatefulWidget {
  const _ChatSessionPaneFooter();

  @override
  State<_ChatSessionPaneFooter> createState() => _ChatSessionPaneFooterState();
}

class _ChatSessionPaneFooterState extends State<_ChatSessionPaneFooter> {
  bool _isResizing = false;
  double _pointerDownDy = 0;
  double _height = 240;
  double _baseHeight = 0;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Listener(
            onPointerCancel: (event) {
              _isResizing = false;
              setState(() {});
            },
            onPointerUp: (event) {
              _isResizing = false;
              setState(() {});
            },
            onPointerDown: (PointerDownEvent event) {
              _baseHeight = _height;
              _pointerDownDy = event.position.dy;
              _isResizing = true;
              setState(() {});
            },
            onPointerMove: (event) {
              final delta = _pointerDownDy - event.position.dy;
              final newHeight =
                  (_baseHeight + delta).clamp(130, 500).roundToDouble();
              if (newHeight != _height) {
                _height = newHeight;
                setState(() {});
              }
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeUpDown,
              child: _isResizing
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: THorizontalDivider(
                        color: ThemeConfig.primary,
                        thickness: 4,
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: THorizontalDivider(
                        color: ThemeConfig.chatSessionPaneDividerColor,
                      ),
                    ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: _height),
            child: const ChatSessionPaneFooter(),
          )
        ],
      );
}
