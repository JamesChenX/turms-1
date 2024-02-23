import 'dart:async';

import 'package:http/http.dart' as http;

import '../io/file_utils.dart';
import 'downloaded_file.dart';

class HttpUtils {
  HttpUtils._();

  static Future<DownloadedFile?> downloadFile(
      {String method = 'GET',
      required Uri uri,
      required String filePath,
      void Function(double progress)? onProgress}) async {
    final response = await http.Client().send(http.Request(method, uri));
    final total = response.contentLength ?? 0;
    if (total <= 0) {
      return null;
    }
    var received = 0;
    final bytes = <int>[];
    final completer = Completer<DownloadedFile?>();
    response.stream.listen(
        (value) {
          bytes.addAll(value);
          received += value.length;
          onProgress?.call(received / total);
        },
        onError: completer.completeError,
        onDone: () async {
          if (bytes.isEmpty) {
            completer.complete();
            return;
          }
          final file = await FileUtils.writeAsBytes(filePath, bytes);
          completer.complete(DownloadedFile(file: file, bytes: bytes));
        });
    return completer.future;
  }
}
