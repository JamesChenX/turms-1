import 'package:flutter/material.dart';

// class EmojiEmbedBuilder extends EmbedBuilder {
//   @override
//   Widget build(BuildContext context, QuillController controller, Embed node,
//           bool readOnly, bool inline, TextStyle textStyle) =>
//       Flexible(
//         child: Text(
//           node.value.data as String,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontFamily: 'NotoColorEmoji',
//             fontSize: 24,
//           ),
//         ),
//       );
//
//   @override
//   String toPlainText(Embed node) => node.value.data as String;
//
//   @override
//   String get key => 'emoji';
// }