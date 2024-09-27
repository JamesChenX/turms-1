import 'package:flutter/cupertino.dart';

import '../../../themes/theme_config.dart';

class TLoadingIndicator extends StatelessWidget {
  const TLoadingIndicator({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const RepaintBoundary(
            child: CupertinoActivityIndicator(),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: ThemeConfig.textStyleSecondary,
          ),
        ],
      );
}