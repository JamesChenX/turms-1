import 'package:pixel_snap/material.dart';

class TCircle extends StatelessWidget {
  const TCircle(
      {super.key,
      this.size = 18,
      this.backgroundColor = Colors.blue,
      required this.child});

  final double size;
  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          // borderRadius: BorderRadius.circular(50 / 2),
        ),
        child: Center(
          child: child,
        ),
      );
}
