import 'dart:io';

class DownloadedFile {
  DownloadedFile({required this.file, required this.bytes});

  final File file;
  final List<int> bytes;
}
