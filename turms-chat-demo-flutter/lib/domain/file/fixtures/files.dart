import '../models/file_info.dart';

final fixtureFiles = List.filled(
    50,
    FileInfo(
        name: 'cat.gif',
        uploadDate: DateTime.now(),
        uploader: 'myself',
        type: 'gif',
        size: 123456));
