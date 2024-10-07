import 'package:flutter/material.dart';

import '../../../themes/index.dart';

class THorizontalDivider extends StatelessWidget {
  const THorizontalDivider({Key? key, this.color, this.thickness = 1.0})
      : super(key: key);

  final Color? color;
  final double thickness;

  @override
  Widget build(BuildContext context) => SizedBox(
      width: double.infinity,
      height: thickness,
      child: DecoratedBox(
          decoration: BoxDecoration(
        color: color ?? context.theme.dividerColor,
      )));
}
