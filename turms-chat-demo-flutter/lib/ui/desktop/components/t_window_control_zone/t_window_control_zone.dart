import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/window/view_models/window_maximized_view_model.dart';
import '../../../../infra/window/window_utils.dart';

class TWindowControlZone extends ConsumerWidget {
  const TWindowControlZone(
      {super.key, required this.toggleMaximizeOnDoubleTap, this.child});

  final bool toggleMaximizeOnDoubleTap;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (details) {
          WindowUtils.startDragging();
        },
        onDoubleTap: toggleMaximizeOnDoubleTap
            ? () async {
                final isWindowMaximized = ref.read(isWindowMaximizedViewModel);
                if (isWindowMaximized) {
                  await WindowUtils.unmaximize();
                } else {
                  await WindowUtils.maximize();
                }
              }
            : null,
        child: child ?? const SizedBox.expand(),
      );
}