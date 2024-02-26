import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

part 't_screenshot_controller.dart';

class TScreenshot extends StatelessWidget {
  const TScreenshot({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  final Widget child;
  final TScreenshotController controller;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
        key: controller._containerKey,
        child: child,
      );
}
