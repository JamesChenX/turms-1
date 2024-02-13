import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/components.dart';
import '../../../../components/t_drawer/t_drawer.dart';
import '../../../../components/t_empty.dart';
import '../../../../components/t_window_control_zone.dart';
import '../../../../themes/theme_config.dart';
import '../view_models/selected_conversation_view_model.dart';
import 'chat_session_details_page/chat_session_details_page.dart';
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
          Container(
            height: ThemeConfig.homePageHeaderHeight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color.fromARGB(255, 231, 231, 231)))),
            child: ChatSessionPaneHeader(drawerController),
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: ChatSessionPaneBody(selectedConversation)),
                    _ChatSessionPaneFooter(),
                    // Listener(
                    //   child: MouseRegion(
                    //     cursor: SystemMouseCursors.move,
                    //     child: Container(
                    //       color: Colors.red,
                    //       height: 8,
                    //     ),
                    //   ),
                    // ),
                    // ConstrainedBox(
                    //   constraints: const BoxConstraints.tightFor(height: 240),
                    //   child: const ChatSessionPaneFooter(),
                    // )
                  ],
                ),
                TapRegion(
                    groupId: chatSessionDetailsDrawerGroupId,
                    onTapOutside: (event) {
                      drawerController.hide?.call();
                    },
                    child: TDrawer(
                        controller: drawerController,
                        child: const ChatSessionDetailsPage())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatSessionPaneFooter extends StatefulWidget {
  const _ChatSessionPaneFooter({super.key});

  @override
  State<_ChatSessionPaneFooter> createState() => _ChatSessionPaneFooterState();
}

class _ChatSessionPaneFooterState extends State<_ChatSessionPaneFooter> {
  double pointerDownDy = 0;
  double height = 240;
  double baseHeight = 0;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Listener(
            onPointerDown: (PointerDownEvent event) {
              baseHeight = height;
              pointerDownDy = event.position.dy;
            },
            onPointerMove: (event) {
              final delta = pointerDownDy - event.position.dy;
              final newHeight =
                  (baseHeight + delta).clamp(130, 500).roundToDouble();
              if (newHeight != height) {
                height = newHeight;
                setState(() {});
              }
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.move,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: THorizontalDivider(
                  color: ThemeConfig.colorChatSessionPaneSeparator,
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: height),
            child: const ChatSessionPaneFooter(),
          )
        ],
      );
}