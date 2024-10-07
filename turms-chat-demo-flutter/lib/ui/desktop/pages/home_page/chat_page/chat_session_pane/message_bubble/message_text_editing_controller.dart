import '../../../../../components/t_editor/t_editor.dart';

class MessageTextEditingController extends EmojiTextEditingController {
  factory MessageTextEditingController.fromValue(String text) {
    // TODO
    return MessageTextEditingController(text: text);
  }

  MessageTextEditingController({required String text}) : super(text: text);
}
