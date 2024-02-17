import 'dart:io';

import '../app/app_config.dart';

class PathUtils {
  PathUtils._();

  static String joinAppPath(List<String> paths) =>
      '${AppConfig.appDir}${Platform.pathSeparator}${paths.join(Platform.pathSeparator)}';
}