import 'package:flutter/foundation.dart';

final class PlatformUtils {
  PlatformUtils._();

  static bool checkPlatforms(List<TargetPlatform> platforms,
      {bool web = false}) {
    if (web && kIsWeb) {
      return true;
    }
    return platforms.contains(defaultTargetPlatform);
  }

  static bool checkPlatform(TargetPlatform platform, {bool web = false}) {
    if (web && kIsWeb) {
      return true;
    }
    return defaultTargetPlatform == platform;
  }
}
