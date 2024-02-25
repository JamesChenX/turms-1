import 'package:flutter/material.dart';

import '../../../infra/animation/animation_extensions.dart';

part 't_drawer_controller.dart';

part 't_drawer_route.dart';

class TDrawer extends StatefulWidget {
  const TDrawer({super.key, this.controller, required this.child});

  final Widget child;
  final TDrawerController? controller;

  @override
  State<TDrawer> createState() => _TDrawerState(controller);
}

class _TDrawerState extends State<TDrawer> with SingleTickerProviderStateMixin {
  _TDrawerState(TDrawerController? controller) {
    controller?.toggle = toggle;
    controller?.show = show;
    controller?.hide = hide;
  }

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _TDrawerView(
        animation: animationController,
        child: widget.child,
      );

  @override
  void didUpdateWidget(TDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller?.toggle = toggle;
    widget.controller?.show = show;
    widget.controller?.hide = hide;
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
