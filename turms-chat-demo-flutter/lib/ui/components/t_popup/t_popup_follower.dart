import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../infra/io/global_keyboard_listener.dart';

class TPopupFollowerController {
  void Function()? show;
  void Function()? hide;
}

class TPopupFollower extends StatefulWidget {
  const TPopupFollower(
      {Key? key,
      required this.child,
      required this.onDismissed,
      required this.controller})
      : super(key: key);

  final Widget child;
  final void Function() onDismissed;
  final TPopupFollowerController controller;

  @override
  State<TPopupFollower> createState() => _TPopupFollowerState(controller);
}

class _TPopupFollowerState extends State<TPopupFollower>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  _TPopupFollowerState(TPopupFollowerController controller) {
    controller
      ..show = show
      ..hide = hide;
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
    )..addStatusListener(_handleStatusChanged);

    animation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn);

    show();
  }

  void _handleStatusChanged(AnimationStatus status) {
    assert(mounted);
    switch ((_isTooltipVisible(_animationStatus), _isTooltipVisible(status))) {
      case (true, false):
        widget.onDismissed();
      case (false, true):
      // widget.onDisplay();
      case (true, true) || (false, false):
        break;
    }
    _animationStatus = status;
  }

  static bool _isTooltipVisible(AnimationStatus status) => switch (status) {
        AnimationStatus.completed ||
        AnimationStatus.forward ||
        AnimationStatus.reverse =>
          true,
        AnimationStatus.dismissed => false,
      };

  @override
  Widget build(BuildContext context) => GlobalKeyboardListener(
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            if (_animationController.isCompleted) {
              hide();
              return true;
            }
          }
          return false;
        },
        child: FadeTransition(
          opacity: animation,
          child: SingleChildScrollView(
            child: widget.child,
          ),
        ),
      );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> show() async {
    if (mounted) {
      await _animationController.forward();
    }
  }

  Future<void> hide() async {
    if (mounted) {
      await _animationController.reverse();
    }
  }
}