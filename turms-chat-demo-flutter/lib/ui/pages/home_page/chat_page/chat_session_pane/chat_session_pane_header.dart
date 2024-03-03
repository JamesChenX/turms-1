import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../components/t_button/t_icon_button.dart';
import '../../../../components/t_drawer/t_drawer.dart';
import '../../../../components/t_window_control_zone.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../view_models/selected_conversation_view_model.dart';
import 'chat_session_pane.dart';

class ChatSessionPaneHeader extends ConsumerStatefulWidget {
  const ChatSessionPaneHeader(this.drawerController, {super.key});

  final TDrawerController drawerController;

  @override
  ConsumerState<ChatSessionPaneHeader> createState() =>
      _ChatSessionPaneHeaderState();
}

class _ChatSessionPaneHeaderState extends ConsumerState<ChatSessionPaneHeader> {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          const TWindowControlZone(
            toggleMaximizeOnDoubleTap: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Use Flexible to prevent overflow
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 28,
                    right: 128,
                  ),
                  child: SelectionArea(
                    child: Text(
                      ref.watch(selectedConversationViewModel)?.name ?? '',
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TapRegion(
                    groupId: chatSessionDetailsDrawerGroupId,
                    child: TIconButton(
                      onTap: () => widget.drawerController.toggle!.call(),
                      tooltip: ref.watch(appLocalizationsViewModel).chatInfo,
                      iconData: Symbols.more_horiz_rounded,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      );
}
