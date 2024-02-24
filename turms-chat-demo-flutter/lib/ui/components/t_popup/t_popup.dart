import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 't_popup_follower.dart';

class TPopup extends StatefulWidget {
  const TPopup(
      {super.key,
      required this.target,
      required this.follower,
      this.targetAnchor = Alignment.topLeft,
      this.followerAnchor = Alignment.topLeft,
      this.offset = Offset.zero,
      TPopupController? controller,
      this.constrainFollowerWithTargetWidth = false,
      this.onDismissed})
      : _controller = controller;

  final Widget target;
  final Widget follower;

  final Alignment followerAnchor;
  final Alignment targetAnchor;
  final Offset offset;

  final bool constrainFollowerWithTargetWidth;

  final TPopupController? _controller;
  final VoidCallback? onDismissed;

  @override
  State createState() => _TPopupState(_controller);
}

class _TPopupState extends State<TPopup> {
  _TPopupState(TPopupController? controller) {
    controller?.showPopover = _showOverlay;
    controller?.hidePopover = _hideOverlay;
  }

  final GlobalKey _targetKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _visible = false;
  final TPopupFollowerController _followerController =
      TPopupFollowerController();

  @override
  void dispose() {
    final controller = widget._controller;
    controller?.showPopover = null;
    controller?.hidePopover = null;
    _removeOverlayEntry();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        key: _targetKey,
        onPanDown: (details) => _toggleOverlay(),
        child: CompositedTransformTarget(
          link: _layerLink,
          child: widget.target,
        ),
      ));

  @override
  void didUpdateWidget(TPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._controller != widget._controller) {
      oldWidget._controller?.showPopover = null;
      oldWidget._controller?.hidePopover = null;
    }
    widget._controller?.showPopover = _showOverlay;
    widget._controller?.hidePopover = _hideOverlay;
  }

  void _toggleOverlay() {
    if (_visible) {
      _hideOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
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

  void _hideOverlay() {
    if (!_visible) {
      return;
    }
    _followerController.hide!.call();
    _visible = false;
  }

  void _removeOverlayEntry() {
    final overlayEntry = _overlayEntry;
    if (overlayEntry != null) {
      overlayEntry.remove();
      _overlayEntry = null;
    }
    _visible = false;
  }

  OverlayEntry _createOverlayEntry() =>
      OverlayEntry(builder: (BuildContext context) {
        final size = MediaQuery.sizeOf(context);
        return UnconstrainedBox(
            child: SizedBox(
                width: size.width,
                height: size.height,
                child: Stack(
                  children: [
                    _buildMask(size),
                    Positioned(
                      child: CompositedTransformFollower(
                        link: _layerLink,
                        followerAnchor: widget.followerAnchor,
                        targetAnchor: widget.targetAnchor,
                        showWhenUnlinked: false,
                        offset: widget.offset,
                        child: TPopupFollower(
                          child: widget.constrainFollowerWithTargetWidth
                              ? SizedBox(
                                  width: _layerLink.leaderSize?.width,
                                  child: widget.follower,
                                )
                              : widget.follower,
                          onDismissed: () {
                            _removeOverlayEntry();
                            widget.onDismissed?.call();
                          },
                          controller: _followerController,
                        ),
                      ),
                    ),
                  ],
                )));
      });

  Widget _buildMask(Size size) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanDown: (details) {
          final targetRenderBox =
              _targetKey.currentContext?.findRenderObject() as RenderBox;
          final hitTest = BoxHitTestResult();
          final position =
              targetRenderBox.globalToLocal(details.globalPosition);
          // If hit the target, we don't hide overlay here,
          // let the target wrapper handle the event.
          if (!targetRenderBox.hitTest(hitTest, position: position)) {
            _hideOverlay();
          }
        },
        child: IgnorePointer(
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.transparent,
          ),
        ),
      );
}

class TPopupController {
  void Function()? showPopover;
  void Function()? hidePopover;
}
