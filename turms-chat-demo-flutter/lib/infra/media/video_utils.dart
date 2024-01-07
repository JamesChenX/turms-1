import 'dart:io';

import 'package:video_player_media_kit/video_player_media_kit.dart';

final class VideoUtils {
  VideoUtils._();

  static void ensureInitialized() {
    if (Platform.isAndroid || Platform.isFuchsia) {
      VideoPlayerMediaKit.ensureInitialized(
        android: true,
      );
    } else if (Platform.isIOS) {
      VideoPlayerMediaKit.ensureInitialized(
        iOS: true,
      );
    } else if (Platform.isWindows) {
      VideoPlayerMediaKit.ensureInitialized(
        windows: true,
      );
    } else if (Platform.isMacOS) {
      VideoPlayerMediaKit.ensureInitialized(
        macOS: true,
      );
    } else if (Platform.isLinux) {
      VideoPlayerMediaKit.ensureInitialized(
        linux: true,
      );
    }
  }
}