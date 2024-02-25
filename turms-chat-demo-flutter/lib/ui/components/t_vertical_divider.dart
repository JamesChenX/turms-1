import 'package:pixel_snap/material.dart';

import '../themes/theme_config.dart';

class TVerticalDivider extends StatelessWidget {
  const TVerticalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
      width: 1,
      height: double.infinity,
      child: DecoratedBox(
          decoration: BoxDecoration(
        color: ThemeConfig.dividerColor,
      )));
}
