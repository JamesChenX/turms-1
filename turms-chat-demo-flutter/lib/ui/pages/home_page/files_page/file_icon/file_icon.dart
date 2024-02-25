import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../../infra/ui/color_extensions.dart';

class _FileIcon {
  const _FileIcon({
    this.color,
    this.iconData,
  });

  factory _FileIcon.fromColor(Color color) => _FileIcon(color: color);

  factory _FileIcon.fromIconData(IconData iconData) =>
      _FileIcon(iconData: iconData);

  final Color? color;
  final IconData? iconData;
}

const _defaultColor = Colors.grey;

// final _formatToIcon = <_FileIcon>{
//   'PDF': _FileIcon.fromColor(const Color.fromARGB(255, 230, 67, 64)),
//   'EPUB': const Color.fromARGB(255, 230, 67, 64),
//   'CHM': const Color.fromARGB(255, 230, 67, 64),
//   'RTF': const Color.fromARGB(255, 230, 67, 64),
//   'HTML': const Color.fromARGB(255, 230, 67, 64),
//   // Office
//   'DOC': const Color.fromARGB(255, 49, 91, 156),
//   'DOCX': const Color.fromARGB(255, 49, 91, 156),
//   'XLS': const Color.fromARGB(255, 8, 119, 65),
//   'XLSX': const Color.fromARGB(255, 8, 119, 65),
//   'PPT': const Color.fromARGB(255, 209, 75, 44),
//   'PPTX': const Color.fromARGB(255, 209, 75, 44),
//   // Text
//   'TXT': Colors.black,
//   'CSV': Colors.black,
//   'XML': Colors.black,
//   'MD': Colors.grey,
//   // Archive
//   'ZIP': Colors.grey,
//   'RAR': Colors.grey,
//   '7Z': Colors.grey,
//   // Image
//   'JPG': Colors.grey,
//   'JPEG': Colors.grey,
//   'PNG': Colors.grey,
//   'GIF': Colors.grey,
//   'BMP': Colors.grey,
//   'WEBP': Colors.grey,
//   'HEIC': Colors.grey,
//   'TIFF': Colors.grey,
//   'PSD': Colors.grey,
//   'RAW': Colors.grey,
//   'AI': Colors.grey,
//   // Audio
//   'MP3': Colors.grey,
//   'WAV': Colors.grey,
//   'FLAC': Colors.grey,
//   'OGG': Colors.grey,
//   'AMR': Colors.grey,
//   'AAC': Colors.grey,
//   'WMA': Colors.grey,
//   'M4A': Colors.grey,
//   'WAVPACK': Colors.grey,
//   'APE': Colors.grey,
//   'AIFF': Colors.grey,
//   'AC3': Colors.grey,
//   'DTS': Colors.grey,
//   'VORBIS': Colors.grey,
//   'WV': Colors.grey,
//   // Video
//   'MP4': Colors.grey,
//   'AVI': Colors.grey,
//   'MKV': Colors.grey,
//   'FLV': Colors.grey,
//   'WEBM': Colors.grey,
//   'MPG': Colors.grey,
//   'WMV': Colors.grey,
//   'AVCHD': Colors.grey
// };

class FileIcon extends StatelessWidget {
  FileIcon({super.key, required String fileFormat})
      : fileFormat = fileFormat.toUpperCase();

  final String fileFormat;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: FileIconPainter(fileFormat),
        size: const Size(21, 28),
      );
}

class FileIconPainter extends CustomPainter {
  FileIconPainter(this.fileFormat, {super.repaint})
      // : color = _formatToIcon[fileFormat] ?? _defaultColor;
      : color = _defaultColor;

  final String fileFormat;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final length = size.width * 0.35;
    final left = size.width - length;
    canvas
      // Clip the corner.
      ..clipPath(Path()
        ..lineTo(left, 0)
        ..lineTo(size.width, length)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close())
      // Clip a rounded rectangle.
      ..drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height),
              const Radius.circular(4)),
          Paint()..color = color)
      // Draw the corner.
      ..drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(left, -length, length * 2, length * 2),
              const Radius.circular(2)),
          Paint()..color = color.darken(0.2));

    // final icon = MdiIcons.check;
    // TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    // textPainter.text = TextSpan(
    //   text: String.fromCharCode(icon.codePoint),
    //   style: TextStyle(
    //     color: Colors.black,
    //     fontSize: size,
    //     fontFamily: icon.fontFamily,
    //     package: icon.fontPackage, // This line is mandatory for external icon packs
    //   ),
    // );
    // textPainter.layout();
    // textPainter.paint(canvas, Offset(x, y));

    final paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      ),
    )
      ..pushStyle(ui.TextStyle(
        color: Colors.white,
        fontSize: 10,
      ))
      ..addText(fileFormat);
    final paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: size.width));
    canvas.drawParagraph(
        paragraph,
        Offset((size.width - paragraph.width) / 2,
            (size.height - paragraph.height) / 2));
  }

  @override
  bool shouldRepaint(FileIconPainter oldDelegate) =>
      fileFormat != oldDelegate.fileFormat;
}
