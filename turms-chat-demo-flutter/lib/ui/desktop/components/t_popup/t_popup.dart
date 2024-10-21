import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 't_floating_popup.dart';
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
      TPopupController? controller,
      this.constrainFollowerWithTargetWidth = false,
      this.onDismissed})
      : _controller = controller;

  final Widget target;
  final Widget follower;

  final Alignment followerAnchor;
  final Alignment targetAnchor;
  final Offset offset;

  final bool followTargetMove;

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
    final oldController = oldWidget._controller;
    final controller = widget._controller;
    if (oldController != null && oldController != controller) {
      oldController
        ..showPopover = null
        ..hidePopover = null;
    }
    if (controller != null) {
      controller
        ..showPopover = _showOverlay
        ..hidePopover = _hideOverlay;
    }
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
      child: _buildFollower());

  Widget _buildFixedFollower() => Positioned.fill(
          child: CustomSingleChildLayout(
        delegate: TPopupLayout(
          targetRect: _getTargetRect(),
          targetAnchor: widget.targetAnchor,
          followerAnchor: widget.followerAnchor,
        ),
        child: _buildFollower(),
      ));

  TapRegion _buildFollower() => TapRegion(
        onTapOutside: (event) {
          _hideOverlay();
        },
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
      );

  Rect _getTargetRect() {
    final renderBox =
        _targetKey.currentContext!.findRenderObject()! as RenderBox;
    final topLeftOffset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    return Rect.fromLTWH(
        topLeftOffset.dx, topLeftOffset.dy, size.width, size.height);
  }
}

class TPopupController {
  void Function()? showPopover;
  void Function()? hidePopover;
}
