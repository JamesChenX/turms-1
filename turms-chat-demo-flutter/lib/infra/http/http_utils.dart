import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

class HttpUtils {
  HttpUtils._();

  static Future<File> downloadFile(
      {String method = 'GET',
      required Uri uri,
      required String filePath,
      void Function(double)? onProgress}) async {
    final response = await http.Client().send(http.Request(method, uri));
    final total = response.contentLength ?? 0;
    if (total <= 0) {
      return File(filePath);
    }
    var received = 0;
    final bytes = <int>[];
    final completer = Completer<File>();
    response.stream.listen(
        (value) {
          bytes.addAll(value);
          received += value.length;
          onProgress?.call(received / total);
        },
        onError: completer.completeError,
        onDone: () async {
          final file = File(filePath);
          await file.writeAsBytes(bytes);
          completer.complete(file);
        });
    return completer.future;
  }
}