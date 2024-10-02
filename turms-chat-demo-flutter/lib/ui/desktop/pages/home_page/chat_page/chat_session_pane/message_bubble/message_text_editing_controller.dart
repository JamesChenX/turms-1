import 'package:fixnum/fixnum.dart';

import '../../../../../components/t_editor/t_editor.dart';

class MessageTextEditingController extends EmojiTextEditingController {
  factory MessageTextEditingController.fromValue(String text) {
    // TODO
    final mentionedUserIds = <Int64>{};
    return MessageTextEditingController(
        text: text, mentionAll: false, mentionedUserIds: mentionedUserIds);
  }

  MessageTextEditingController(
      {required String text,
      required this.mentionAll,
      required this.mentionedUserIds})
      : super(text: text);

  final bool mentionAll;
  final Set<Int64> mentionedUserIds;

  bool isMentioned(Int64 userId) =>
      mentionAll || mentionedUserIds.contains(userId);
}
