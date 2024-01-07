import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TCopyableText extends StatelessWidget {
  const TCopyableText({
    required this.child,
  });

  final Text child;

  @override
  Widget build(BuildContext context) {
    final value = child.data;
    if (value?.isEmpty ?? true) {
      return child;
    }
    return GestureDetector(
      onDoubleTap: () async {
        await Clipboard.setData(ClipboardData(text: value!));
        if (context.mounted) {
          // TODO: show tooltip when copied.
        }
      },
      child: child,
    );
  }
}