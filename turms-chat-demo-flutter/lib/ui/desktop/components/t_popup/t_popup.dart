import 'package:flutter/material.dart';

import '../../../../infra/random/random_utils.dart';
import 't_popup_follower.dart';

class TPopup extends StatefulWidget {
  const TPopup(
      {super.key,
      required this.target,
      required this.follower,
      this.targetAnchor = Alignment.topLeft,
      this.followerAnchor = Alignment.topLeft,
      this.offset = Offset.zero,
      this.followTargetMove = false,
      this.controller,
      this.constrainFollowerWithTargetWidth = false,
      this.onDismissed});

  final Widget target;
  final Widget follower;

  final Alignment followerAnchor;
  final Alignment targetAnchor;
  final Offset offset;

  final bool followTargetMove;

  final bool constrainFollowerWithTargetWidth;

  final TPopupController? controller;
  final VoidCallback? onDismissed;

  @override
  State createState() => _TPopupState();
}

class _TPopupState extends State<TPopup> {
  final GlobalKey _targetKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _visible = false;
  final TPopupFollowerController _followerController =
      TPopupFollowerController();

  @override
  void initState() {
    super.initState();
    final controller = widget.controller;
    if (controller != null) {
      controller
        ..showPopover = _showPopup
        ..hidePopover = _hidePopup;
    }
  }

  @override
  void dispose() {
    final controller = widget.controller;
    if (controller != null) {
      controller
        ..showPopover = null
        ..hidePopover = null;
    }
    _removeOverlayEntry();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        key: _targetKey,
        onPanDown: (details) => _togglePopup(),
        child: CompositedTransformTarget(
          link: _layerLink,
          child: widget.target,
        ),
      ));

  @override
  void didUpdateWidget(TPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldController = oldWidget.controller;
    final controller = widget.controller;
    if (oldController != null && oldController != controller) {
      oldController
        ..showPopover = null
        ..hidePopover = null;
    }
    if (controller != null) {
      controller
        ..showPopover = _showPopup
        ..hidePopover = _hidePopup;
    }
  }

  void _togglePopup() {
    if (_visible) {
      _hidePopup();
    } else {
      _showPopup();
    }
  }

  void _showPopup() {
    if (_visible) {
      return;
    }
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _followerController.show?.call();
    }
    _visible = true;
  }

  void _hidePopup() {
    if (!_visible) {
      return;
    }
    _followerController.hide?.call();
    _visible = false;
  }

  void _removeOverlayEntry() {
    if (_overlayEntry case final OverlayEntry overlayEntry) {
      overlayEntry.remove();
      _overlayEntry = null;
    }
    _visible = false;
  }

  OverlayEntry _createOverlayEntry() => OverlayEntry(
      builder: (BuildContext context) => widget.followTargetMove
          ? _buildTrackingFollower()
          : _buildFixedFollower());

  Widget _buildTrackingFollower() => CompositedTransformFollower(
      link: _layerLink,
      followerAnchor: widget.followerAnchor,
      targetAnchor: widget.targetAnchor,
      offset: widget.offset,
      child: _buildFollower(
          controller: _followerController,
          width: widget.constrainFollowerWithTargetWidth
              ? _layerLink.leaderSize?.width
              : null,
          animate: true,
          onTapOutside: (event) => _hidePopup(),
          onDismissed: () {
            _removeOverlayEntry();
            widget.onDismissed?.call();
          },
          child: widget.follower));

  Widget _buildFixedFollower() => TPopupFixedFollower(
      targetGlobalRect: _getTargetGlobalRect(),
      controller: _followerController,
      child: widget.follower,
      targetAnchor: widget.targetAnchor,
      followerAnchor: widget.followerAnchor,
      onTapOutside: (event) => _hidePopup(),
      onDismissed: () {
        _removeOverlayEntry();
        widget.onDismissed?.call();
      });

  Rect _getTargetGlobalRect() {
    final renderBox =
        _targetKey.currentContext!.findRenderObject()! as RenderBox;
    final topLeftOffset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    return Rect.fromLTWH(
        topLeftOffset.dx, topLeftOffset.dy, size.width, size.height);
  }
}

class TPopupFixedFollower extends StatelessWidget {
  const TPopupFixedFollower({
    super.key,
    required this.controller,
    required this.targetGlobalRect,
    required this.targetAnchor,
    required this.followerAnchor,
    this.followerWidth,
    this.animate = true,
    required this.onTapOutside,
    required this.onDismissed,
    required this.child,
  });

  final TPopupFollowerController controller;
  final Rect targetGlobalRect;
  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final double? followerWidth;
  final bool animate;
  final TapRegionCallback onTapOutside;
  final VoidCallback onDismissed;
  final Widget child;

  @override
  Widget build(BuildContext context) => Positioned.fill(
          child: CustomSingleChildLayout(
        delegate: TPopupLayout(
          targetRect: targetGlobalRect,
          targetAnchor: targetAnchor,
          followerAnchor: followerAnchor,
        ),
        child: Material(
          color: Colors.transparent,
          child: _buildFollower(
            controller: controller,
            width: followerWidth,
            animate: animate,
            onTapOutside: onTapOutside,
            onDismissed: onDismissed,
            child: child,
          ),
        ),
      ));
}

TapRegion _buildFollower({
  required TPopupFollowerController controller,
  required double? width,
  required bool animate,
  required TapRegionCallback onTapOutside,
  required VoidCallback onDismissed,
  required Widget child,
}) =>
    TapRegion(
      onTapOutside: onTapOutside,
      child: TPopupFollower(
        controller: controller,
        animate: animate,
        onDismissed: onDismissed,
        child: width != null
            ? SizedBox(
                width: width,
                child: child,
              )
            : child,
      ),
    );

class TPopupController {
  void Function()? showPopover;
  void Function()? hidePopover;
}

class _TPopupInfo {
  const _TPopupInfo({required this.overlayEntry, required this.hideOrRemove});

  final OverlayEntry overlayEntry;
  final void Function() hideOrRemove;
}

final _idToPopupInfo = <String, _TPopupInfo>{};

void showPopup({
  required BuildContext context,
  String? id,
  bool hideOtherPopups = true,
  bool animate = true,
  required Rect targetGlobalRect,
  required Alignment targetAnchor,
  required Alignment followerAnchor,
  VoidCallback? onDismissed,
  required Widget follower,
}) {
  id ??= RandomUtils.nextUniquePositiveInt64().toString();
  final controller = TPopupFollowerController();
  void hidePopup() {
    controller.hide?.call();
  }

  void removePopup() {
    final removedPopup = _idToPopupInfo.remove(id);
    removedPopup?.overlayEntry.remove();
    onDismissed?.call();
  }

  final hideOrRemove = animate ? hidePopup : removePopup;

  final overlayEntry = OverlayEntry(
    builder: (context) => TPopupFixedFollower(
      targetGlobalRect: targetGlobalRect,
      controller: controller,
      targetAnchor: targetAnchor,
      followerAnchor: followerAnchor,
      animate: animate,
      onTapOutside: (event) {
        hideOrRemove();
      },
      onDismissed: removePopup,
      child: follower,
    ),
  );
  if (hideOtherPopups) {
    hideAllPopups();
  }
  _idToPopupInfo[id] =
      _TPopupInfo(overlayEntry: overlayEntry, hideOrRemove: hideOrRemove);
  Overlay.of(context, rootOverlay: true).insert(overlayEntry);
}

void hideAllPopups() {
  // We need to make a copy of the list
  // because hideOrRemove() may remove the popup from the list
  // while iterating over it.
  final allPopups = _idToPopupInfo.values.toList();
  for (final popup in allPopups) {
    popup.hideOrRemove();
  }
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
