import 'package:flutter/material.dart';

import '../themes/theme_config.dart';

class THorizontalDivider extends StatelessWidget {
  const THorizontalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
      width: double.infinity,
      height: 1,
      child: DecoratedBox(
          decoration: BoxDecoration(
        color: ThemeConfig.dividerColor,
      )));
}