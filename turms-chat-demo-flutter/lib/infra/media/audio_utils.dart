import 'package:media_kit/media_kit.dart';

class AudioUtils {
  AudioUtils._();

  static Future<void> play(String path) async {
    final player = Player();
    await player.stop();
    final media = Media(path);
  }
}
