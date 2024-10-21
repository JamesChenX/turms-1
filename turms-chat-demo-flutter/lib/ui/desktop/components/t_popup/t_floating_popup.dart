import 'package:flutter/material.dart';

class TFloatingPopup extends StatelessWidget {
  const TFloatingPopup(
      {super.key,
      required this.targetRect,
      required this.targetAnchor,
      required this.followerAnchor,
      required this.child});

  final Rect targetRect;
  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final Widget child;

  @override
  Widget build(BuildContext context) => Positioned.fill(
          child: CustomSingleChildLayout(
        delegate: TPopupLayout(
          targetRect: targetRect,
          targetAnchor: targetAnchor,
          followerAnchor: followerAnchor,
        ),
        child: child,
      ));
}

class TPopupLayout extends SingleChildLayoutDelegate {
  const TPopupLayout(
      {required this.targetRect,
      required this.targetAnchor,
      required this.followerAnchor});

  final Rect targetRect;
  final Alignment targetAnchor;
  final Alignment followerAnchor;

  @override
  bool shouldRelayout(TPopupLayout oldDelegate) =>
      targetRect != oldDelegate.targetRect ||
      targetAnchor != oldDelegate.targetAnchor ||
      followerAnchor != oldDelegate.followerAnchor;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) =>
      getPosition(size, childSize);

  Offset getPosition(Size containerSize, Size childSize) {
    final preferredTargetTopLeft = targetRect.topLeft +
        targetAnchor.alongSize(targetRect.size) -
        followerAnchor.alongSize(childSize);
    if (preferredTargetTopLeft.dx < 0 ||
        preferredTargetTopLeft.dx + childSize.width > containerSize.width) {
      if (preferredTargetTopLeft.dy < 0 ||
          preferredTargetTopLeft.dy + childSize.height > containerSize.height) {
        return targetRect.topLeft +
            targetAnchor.alongSize(targetRect.size) -
            followerAnchor.flipped().alongSize(childSize);
      } else {
        return targetRect.topLeft +
            targetAnchor.alongSize(targetRect.size) -
            followerAnchor.flippedX().alongSize(childSize);
      }
    } else if (preferredTargetTopLeft.dy < 0 ||
        preferredTargetTopLeft.dy + childSize.height > containerSize.height) {
      return targetRect.topLeft +
          targetAnchor.alongSize(targetRect.size) -
          followerAnchor.flippedY().alongSize(childSize);
    }
    return preferredTargetTopLeft;
  }
}

extension on Alignment {
  Alignment flipped() => Alignment(-x, -y);

  Alignment flippedX() => Alignment(-x, y);

  Alignment flippedY() => Alignment(x, -y);
}
