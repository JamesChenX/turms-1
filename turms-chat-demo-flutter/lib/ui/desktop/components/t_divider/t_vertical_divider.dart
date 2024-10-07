import 'package:flutter/material.dart';

import '../../../themes/index.dart';

class TVerticalDivider extends StatelessWidget {
  const TVerticalDivider({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox(
      width: 1,
      height: double.infinity,
      child: DecoratedBox(
          decoration: BoxDecoration(
        color: color ?? context.theme.dividerColor,
      )));
}
