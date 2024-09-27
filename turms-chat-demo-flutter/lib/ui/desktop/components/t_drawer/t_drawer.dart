import 'package:flutter/material.dart';

import '../../../../infra/animation/animation_extensions.dart';

part 't_drawer_controller.dart';

part 't_drawer_route.dart';

class TDrawer extends StatefulWidget {
  const TDrawer({super.key, this.controller, required this.child});

  final TDrawerController? controller;
  final Widget child;

  @override
  State<TDrawer> createState() => _TDrawerState(controller);
}

class _TDrawerState extends State<TDrawer> with SingleTickerProviderStateMixin {
  _TDrawerState(TDrawerController? controller) {
    controller?.toggle = toggle;
    controller?.show = show;
    controller?.hide = hide;
  }

  late Widget currentChild;
  Widget? nextChild;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    currentChild = widget.child;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    final controller = widget.controller;
    controller?.toggle = null;
    controller?.show = null;
    controller?.hide = null;
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _TDrawerView(
        animation: animationController,
        child: currentChild,
      );

  @override
  void didUpdateWidget(TDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newController = widget.controller;
    newController?.toggle = toggle;
    newController?.show = show;
    newController?.hide = hide;
    // Only change to show the next child
    // if the drawer is not visible,
    // or the drawer is hidden and show again.
    if (animationController.status.isNotDismissed) {
      nextChild = widget.child;
    } else {
      nextChild = null;
      currentChild = widget.child;
    }
  }

  void toggle() {
    if (animationController.status.isDismissed) {
      show();
    } else {
      hide();
    }
  }

  void show() {
    animationController.forward();
    if (nextChild != null) {
      currentChild = nextChild!;
      nextChild = null;
      setState(() {});
    }
  }

  void hide() {
    animationController.reverse();
  }
}

class _TDrawerView extends StatelessWidget {
  const _TDrawerView({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: SizeTransition(
          axis: Axis.horizontal,
          sizeFactor: animation.drive(Tween<double>(begin: 0, end: 1)
              .chain(CurveTween(curve: Curves.fastOutSlowIn))),
          child: child,
        ),
      );
}

void showTDrawer(BuildContext context, Widget child) =>
    Navigator.of(context).push(_TDrawerRoute<Widget>(child));