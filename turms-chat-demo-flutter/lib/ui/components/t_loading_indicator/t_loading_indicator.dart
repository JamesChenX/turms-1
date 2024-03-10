import 'package:flutter/cupertino.dart';

class TLoadingIndicator extends StatelessWidget {
  const TLoadingIndicator({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(text),
          const SizedBox(
            width: 8,
          ),
          const RepaintBoundary(
            child: CupertinoActivityIndicator(),
          ),
        ],
      );
}
