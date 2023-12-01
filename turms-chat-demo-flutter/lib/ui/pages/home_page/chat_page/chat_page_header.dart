import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../domain/window/view_models/window_maximized_view_model.dart';
import '../../../../infra/window/window_utils.dart';

class ChatPageHeader extends ConsumerStatefulWidget {
  const ChatPageHeader({super.key});

  @override
  ConsumerState<ChatPageHeader> createState() => _MessagePaneHeaderState();
}

class _MessagePaneHeaderState extends ConsumerState<ChatPageHeader> {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (details) {
              WindowUtils.startDragging();
            },
            onDoubleTap: () async {
              final isWindowMaximized = ref.read(isWindowMaximizedViewModel);
              if (isWindowMaximized) {
                await WindowUtils.unmaximize();
              } else {
                await WindowUtils.maximize();
              }
            },
            child: const SizedBox.expand(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 28,
                ),
                child: const Text(
                  'test',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => {},
                      tooltip: 'More',
                      style: IconButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          minimumSize: const Size(34, 26),
                          maximumSize: const Size(34, 26),
                          shape: const RoundedRectangleBorder(),
                          animationDuration: Duration.zero),
                      icon: const Icon(
                        Symbols.more_horiz,
                        size: 16,
                        color: Color.fromARGB(255, 67, 67, 67),
                      ))
                ],
              )
            ],
          )
        ],
      );
}