import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import '../app/app_config.dart';

class FileUtils {
  FileUtils._();

  // static String? getFileExtension(String? mimeType) {
  //   if (mimeType == null) {
  //     return null;
  //   }
  //   return Mime.getExtensionsFromType(mimeType)?[0];
  // }

  static Future<String?> getFileDownloadPath(String name, String? ext) async {
    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir == null) {
      return null;
    }
    ext = (ext != null) ? '.$ext' : '';
    var path =
        '${downloadsDir.path}/${AppConfig.packageInfo.packageName}/$name$ext';
    var num = 1;
    while (await File(path).exists()) {
      path =
          '${downloadsDir.path}/${AppConfig.packageInfo.packageName}/$name (${num++})$ext';
    }
    return path;
  }

  static Future<void> saveFile(String path, Uint8List content) async {
    final file = File(path);
    await file.writeAsBytes(content);
  }
}