import 'package:pixel_snap/material.dart';
import 'package:flutter/services.dart';

import '../../infra/built_in_types/built_in_type_helpers.dart';

class TCopyableText extends StatelessWidget {
  const TCopyableText({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Text child;

  @override
  Widget build(BuildContext context) {
    final value = child.data;
    if (value?.isBlank ?? true) {
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
