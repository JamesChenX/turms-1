import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../themes/index.dart';
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
    final appThemeExtension = context.appThemeExtension;
    final selectedConversation = ref.watch(selectedConversationViewModel);
    if (selectedConversation == null) {
      return const TWindowControlZone(
          toggleMaximizeOnDoubleTap: true, child: TEmpty());
    }
    return ColoredBox(
      color: appThemeExtension.homePageBackgroundColor,
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: appThemeExtension.chatSessionPaneDividerColor))),
            child: Padding(
              // Note that we need the padding to make the border
              // the same height  with the header of the sub navigation rail.
              padding: const EdgeInsets.only(bottom: 1),
              child: SizedBox(
                height: Sizes.homePageHeaderHeight,
                child: ChatSessionPaneHeader(drawerController),
              ),
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
  Widget build(BuildContext context) {
    final theme = context.theme;
    final appThemeExtension = context.appThemeExtension;
    return Column(
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
                ? Padding(
                    padding: Sizes.paddingV2,
                    child: THorizontalDivider(
                      color: theme.primaryColor,
                      thickness: 4,
                    ),
                  )
                : Padding(
                    padding: Sizes.paddingV4,
                    child: THorizontalDivider(
                      color: appThemeExtension.chatSessionPaneDividerColor,
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
}
