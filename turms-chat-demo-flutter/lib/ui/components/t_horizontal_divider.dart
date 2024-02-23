import 'package:flutter/material.dart';

import '../themes/theme_config.dart';

class THorizontalDivider extends StatelessWidget {
  const THorizontalDivider({Key? key, this.color = ThemeConfig.dividerColor})
      : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
      width: double.infinity,
      height: 1,
      child: DecoratedBox(
          decoration: BoxDecoration(
        color: color,
      )));
}
