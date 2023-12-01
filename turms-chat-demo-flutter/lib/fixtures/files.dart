import '../ui/pages/home_page/files_page/files_page.dart';

final fixtureFiles = List.filled(
    50,
    FileInfo(
        name: 'cat.gif',
        uploadDate: DateTime.now(),
        uploader: 'myself',
        type: 'gif',
        size: 123456));