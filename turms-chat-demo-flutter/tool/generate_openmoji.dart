import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

const List<String> reservedKeyword = ['switch', 'return'];

final Directory assetsDirectory = Directory('assets');
final Directory fontsDirectory =
    Directory('${assetsDirectory.path}${separator}fonts');

final File openmojiColorFontFile =
    File('${fontsDirectory.path}${separator}OpenMoji-Color.ttf');

final File openmojiMetadataFile =
    File('${Directory.systemTemp.path}${separator}openmoji.json');

const String openmojiMetadataUrl =
    'https://github.com/hfg-gmuend/openmoji/raw/master/data/openmoji.json';

const String openmojiColorFontFileUrl =
    'https://github.com/hfg-gmuend/openmoji/raw/master/font/OpenMoji-color-glyf_colr_0/OpenMoji-color-glyf_colr_0.ttf';

final File openmojiIconsClass =
    File('lib${separator}emojis${separator}openmoji_icons.dart');

// lang=dart
const String openmojiIconsClassTemplate = """
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

@immutable
class OpenmojiIcons {

  const OpenmojiIcons._();

  @icons

}
""";

Future<void> main() async {
  await _prepareDirectories();
  await _downloadFonts();
  await _downloadMetadata();
  await _generateIconsClass();

  stdout.writeln('Deleting metadata file');
  await openmojiMetadataFile.delete();
}

Future<void> _generateIconsClass() async {
  final stringBuffer = StringBuffer();

  stdout.writeln('Generating icons class');

  final source = await openmojiMetadataFile.readAsString();
  final jsonData = jsonDecode(source) as List<dynamic>;

  for (final rawData in jsonData) {
    final data = rawData as Map;
    var prefix = '';
    final hexCode = data['hexcode'].toString();

    if (hexCode.contains('-')) {
      continue;
    }

    final category = data['group'].toString();
    if (category.trim().toLowerCase().startsWith('extras')) {
      prefix = 'extras_';
    }

    var annotation = data['annotation'].toString();

    if (reservedKeyword.contains(annotation)) {
      annotation = '${annotation}_icon';
    }

    final formattedAnnotation = annotation
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_')
        .replaceAll('!', '')
        .replaceAll('“', '')
        .replaceAll('”', '')
        .replaceAll(':', '')
        .replaceAll('.', '')
        .replaceAll('ä', 'a')
        .replaceAll('ü', 'u')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('’', '')
        .replaceAll('ñ', 'n')
        .replaceAll('1st', 'first')
        .replaceAll('2nd', 'second')
        .replaceAll('3rd', 'third');

    stringBuffer
      ..writeln(
          "static const IconData $prefix$formattedAnnotation = IconData(0x$hexCode, fontFamily: 'OpenMoji-Color', fontPackage: 'flutter_openmoji');")
      ..writeln();
  }

  final classContent =
      openmojiIconsClassTemplate.replaceAll('@icons', stringBuffer.toString());

  if (await openmojiIconsClass.exists()) {
    await openmojiIconsClass.delete();
  }
  await openmojiIconsClass.writeAsString(classContent);
}

Future<void> _downloadMetadata() async {
  stdout.writeln('Downloading OpenMoji metadata file');
  final uri = Uri.parse(openmojiMetadataUrl);
  final response = await get(uri);
  if (response.statusCode != 200) {
    stderr.writeln('Failed to download metadata file: ${response.statusCode}');
    exit(-1);
  }
  await openmojiMetadataFile.writeAsBytes(response.bodyBytes);
}

Future<void> _downloadFonts() async {
  stdout.writeln('Downloading OpenMoji color font file');
  final uri = Uri.parse(openmojiColorFontFileUrl);
  final response = await get(uri);
  if (response.statusCode != 200) {
    stderr.writeln('Failed to download font file: ${response.statusCode}');
    exit(-1);
  }
  await openmojiColorFontFile.writeAsBytes(response.bodyBytes);
}

Future<void> _prepareDirectories() async {
  stdout.writeln('Creating assets directory');

  if (!await assetsDirectory.exists()) {
    await assetsDirectory.create();
  }

  stdout.writeln('Creating fonts directory');
  if (!await fontsDirectory.exists()) {
    await fontsDirectory.create();
  }
}
