import 'dart:math';

import 'package:flutter/widgets.dart';

class ScrollUtils {
  ScrollUtils._();

  static void ensureVisible(ScrollController controller, double viewportHeight,
      double itemOffset, double itemHeight) {
    if (checkIfOffsetInViewport(
        controller, viewportHeight, itemOffset, itemHeight)) {
      return;
    }
    final moveOffset1 = controller.offset - itemOffset;
    if (moveOffset1 < 0) {
      controller.jumpTo(min(controller.position.maxScrollExtent,
          itemOffset + itemHeight - viewportHeight));
    } else {
      final moveOffset2 =
          itemOffset + itemHeight - controller.offset - viewportHeight;
      if (moveOffset2 < 0 || moveOffset1 < moveOffset2) {
        controller.jumpTo(max(controller.position.minScrollExtent, itemOffset));
      } else {
        controller.jumpTo(min(controller.position.maxScrollExtent,
            itemOffset + itemHeight - viewportHeight));
      }
    }
  }

  static bool checkIfOffsetInViewport(ScrollController controller,
      double viewportHeight, double itemOffset, double itemHeight) {
    final offset = controller.offset;
    return offset <= itemOffset &&
        (itemOffset + itemHeight) <= (offset + viewportHeight);
  }
}
