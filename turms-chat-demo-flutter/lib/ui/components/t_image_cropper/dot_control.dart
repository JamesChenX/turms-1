import 'package:flutter/material.dart';

const dotContainerSize = 32.0;

class DotControl extends StatelessWidget {
  const DotControl({
    Key? key,
    this.color = Colors.white,
    this.padding = 8,
  }) : super(key: key);

  final Color color;

  /// Used to make dot easier to touch.
  final double padding;

  @override
  Widget build(BuildContext context) {
    final dotSize = dotContainerSize - (padding * 2);
    return SizedBox(
      width: dotContainerSize,
      height: dotContainerSize,
      child: Center(
        child: ClipRRect(
          borderRadius:
              const BorderRadius.all(Radius.circular(dotContainerSize)),
          child: SizedBox(
            width: dotSize,
            height: dotSize,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
