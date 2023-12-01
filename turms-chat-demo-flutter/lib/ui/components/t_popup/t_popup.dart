import 'package:flutter/material.dart';
import 'package:turms_chat_demo/ui/components/t_popup/t_popup_follower.dart';

class TPopup extends StatefulWidget {
  const TPopup({super.key,
    required this.target,
    required this.follower,
    this.targetAnchor = Alignment.topLeft,
    this.followerAnchor = Alignment.topLeft,
    this.offset = Offset.zero,
    TPopupController? controller})
      : _controller = controller;

  final Widget target;
  final Widget follower;

  final Alignment followerAnchor;
  final Alignment targetAnchor;
  final Offset offset;

  final TPopupController? _controller;

  @override
  State createState() => _TPopupState(_controller);
}

class _TPopupState extends State<TPopup> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _visible = false;
  final TPopupFollowerController _followerController = TPopupFollowerController();

  _TPopupState(TPopupController? controller) {
    controller?.hidePopover = _hideOverlay;
  }

  @override
  Widget build(BuildContext context) =>
      MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggleOverlay,
            child: CompositedTransformTarget(
              link: _layerLink,
              child: widget.target,
            ),
          ));

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

  @override
  void dispose() {
    _removeOverlayEntry();
    super.dispose();
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
                          child: widget.follower,
                          onDismissed: _removeOverlayEntry,
                          controller: _followerController,
                        ),
                      ),
                    ),
                  ],
                )));
      });

  GestureDetector _buildMask(Size size) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        // Do not use "onTap",
        // otherwise we will prevent widgets behind
        // the child container from receiving the "onTap" event.
        onPanDown: (details) {
          _hideOverlay();
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
  late void Function() hidePopover;
}