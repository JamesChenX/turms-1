import 'package:flutter/animation.dart';

import 'dismissed_status_change_type.dart';

final class AnimationUtils {
  AnimationUtils._();

  static DismissedStatusChangeType detectDismissedStatusChange(
      AnimationStatus previousStatus, AnimationStatus status) {
    switch ((previousStatus.isDismissed, status.isDismissed)) {
      case (false, true):
        return DismissedStatusChangeType.becomeDismissed;
      case (true, false):
        return DismissedStatusChangeType.becomeNotDismissed;
      case (true, true) || (false, false):
        return DismissedStatusChangeType.noChange;
    }
  }
}
